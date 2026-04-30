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

    public init(urlSession: URLSession = .shared,
                urlResponseValidator: ResponseValidator = ResponseValidatorImpl(),
                decoder: RequestDecodable = RequestDecoder()) {
        self.urlSession = urlSession
        self.urlResponseValidator = urlResponseValidator
        self.decoder = decoder
    }

    public func perform<T>(request: any Request, decodeTo decodableObject: T.Type) async throws -> T where T: Decodable {
        guard let urlRequest = request.urlRequest() else {
            throw NetworkingError.internalError(.noRequest)
        }
        do {
            let (data, response) = try await urlSession.data(for: urlRequest)
            try urlResponseValidator.validateStatus(from: response)
            let validData = try urlResponseValidator.validateData(data)
            return try decoder.decode(T.self, from: validData)
        } catch let error as NetworkingError {
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
}
