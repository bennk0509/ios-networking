//
//  AsyncRequestPerformer.swift
//  ios-networking
//
//  Created by Khanh Anh Kiet on 2026-04-25.
//

import Foundation

public protocol AsyncRequestPerformable {
    func perform<T: Decodable>(request: any Request, decodeTo decodableObject: T.Type) async throws -> T
    func perform(request: any Request) async throws
}

public struct AsyncRequestPerformer: AsyncRequestPerformable {

    private let urlSession: URLSession
    private let urlResponseValidator: ResponseValidator
    private let decoder: RequestDecodable
    
    private let interceptors: [RequestInterceptor]
    

    public init(urlSession: URLSession = .shared,
                urlResponseValidator: ResponseValidator = ResponseValidatorImpl(),
                decoder: RequestDecodable = RequestDecoder(),
                interceptors: [RequestInterceptor] = []) {
        self.urlSession = urlSession
        self.urlResponseValidator = urlResponseValidator
        self.decoder = decoder
        self.interceptors = interceptors
    }

    public func perform<T>(request: any Request, decodeTo decodableObject: T.Type) async throws -> T where T: Decodable {
        
        //guard request
        guard let urlRequest = request.urlRequest() else {
            throw NetworkingError.internalError(.noRequest)
        }
 
        //apply interceptor to request
        var adaptedRequest = urlRequest
        for interceptor in interceptors {
            adaptedRequest = try await interceptor.adapt(adaptedRequest)
        }
        
        //send to network and receive response
        var res: URLResponse?
        
        do {
            //get the response
            let (data, response) = try await urlSession.data(for: adaptedRequest)
            res = response
            //validate response
            try urlResponseValidator.validateStatus(from: response)
            //validate data
            let validData = try urlResponseValidator.validateData(data)
            //decode
            return try decoder.decode(T.self, from: validData)
        } catch let error as NetworkingError {
            //try again if network error
            let decision = try await shouldRetry(adaptedRequest, error: error, response: res)
            if decision == .retry {
                return try await perform(request: request, decodeTo: decodableObject)
            }
            throw error
        } catch {
            throw NetworkingError.internalError(.unknown)
        }
    }

    public func perform(request: any Request) async throws {
        guard let urlRequest = request.urlRequest() else {
            throw NetworkingError.internalError(.noRequest)
        }
        do {
            let (data, response) = try await urlSession.data(for: urlRequest)
            try urlResponseValidator.validateStatus(from: response)
            _ = try urlResponseValidator.validateData(data)
        } catch let error as NetworkingError {
            throw error
        } catch {
            throw NetworkingError.internalError(.unknown)
        }
    }
    
    private func shouldRetry(_ urlRequest: URLRequest, error: Error, response: URLResponse?) async throws -> RetryDecision {
        for interceptor in interceptors {
            let decision = try await interceptor.retry(urlRequest, dueTo: error, response: response)
            if decision == .retry { return .retry }
        }
        return .doNotRetry
    }
}
