//
//  AsyncRequestPerformer.swift
//  ios-networking
//
//  Created by Khanh Anh Kiet on 2026-04-25.
//

import Foundation

public protocol AsyncRequestPerformable{
    func perform<T: Decodable>(request: URLRequest, decodeTo decodableObject: T.Type) async throws -> T
    func perform(request: URLRequest) async throws
}


public struct AsyncRequestPerformer: AsyncRequestPerformable{
    
    private let urlSession: URLSession
    private let urlResponseValidator: URLResponseValidator
    private let decoder: RequestDecodable
    
    public init(urlSession: URLSession = .shared,
                urlResponseValidator: URLResponseValidator = URLResponseValidatorImpl(),
                decoder: RequestDecodable = RequestDecoder()) {
        self.urlSession = urlSession
        self.urlResponseValidator = urlResponseValidator
        self.decoder = decoder
    }
    
    public func perform<T>(request: URLRequest, decodeTo decodableObject: T.Type) async throws -> T where T : Decodable {
        do{
            let (data, response) = try await urlSession.data(for: request)
            let validData = try urlResponseValidator.validate(data: data, urlResponse: response, error: nil)
            return try decoder.decode(T.self, from: validData)
        } catch let error as NetworkingError {
            throw error
        } catch {
            throw NetworkingError.unknown
        }
    }
    
    public func perform(request: URLRequest) async throws {
        do{
            let (data, response) = try await urlSession.data(for: request)
            _ = try urlResponseValidator.validate(data: data, urlResponse: response, error: nil)
        } catch let error as NetworkingError {
            throw error
        } catch {
            throw NetworkingError.unknown
        }
    }
    
    
    
}
