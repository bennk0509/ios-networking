//
//  AuthenticationInterceptor.swift
//  ios-networking
//
//  Created by Khanh Anh Kiet on 2026-05-02.
//

import Foundation


public final class AuthenticationInterceptor: RequestInterceptor {
    
    private let tokenProvider: TokenProvider
    
    public init(tokenProvider: TokenProvider) {
        self.tokenProvider = tokenProvider
    }
    
    public func adapt(_ urlRequest: URLRequest) async throws -> URLRequest {
        var request = urlRequest
        let token = try await tokenProvider.accessToken()
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    public func retry(_ urlRequest: URLRequest, dueTo error: any Error, response: URLResponse?) async throws -> RetryDecision {
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 401 else {
            return .doNotRetry
        }
        try await tokenProvider.refreshToken()
        return .retry
    }
    
    
}
