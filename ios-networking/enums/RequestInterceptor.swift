//
//  RequestInterceptor.swift
//  ios-networking
//
//  Created by Khanh Anh Kiet on 2026-05-02.
//

import Foundation

public enum RetryDecision {
    case retry
    case doNotRetry
}

public protocol RequestInterceptor {
    //edit the request before sending to network
    func adapt(_ urlRequest: URLRequest) async throws -> URLRequest
    
    // receive error response -> send back to network
    func retry(_ urlRequest: URLRequest, dueTo error: Error, response: URLResponse?) async throws -> RetryDecision
}
