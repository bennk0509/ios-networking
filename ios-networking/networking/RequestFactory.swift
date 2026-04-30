//
//  RequestFactory.swift
//  ios-networking
//
//  Created by Khanh Anh Kiet on 2026-04-25.
//

import Foundation

public protocol RequestFactory {
    func build(httpMethod: HTTPMethod,
               urlString: String,
               parameters: [HTTPParameter]?,
               headers: [HTTPHeader]?,
               body: HTTPBody?,
               timeoutInterval: TimeInterval) -> (any Request)?
}

public class RequestFactoryImpl: RequestFactory {

    private struct ConcreteRequest: Request {
        let httpMethod: HTTPMethod
        let urlString: String
        let parameters: [HTTPParameter]?
        let headers: [HTTPHeader]?
        let body: Data?
        let timeoutInterval: TimeInterval
    }

    public init() {}

    public func build(httpMethod: HTTPMethod,
                      urlString: String,
                      parameters: [HTTPParameter]? = nil,
                      headers: [HTTPHeader]? = nil,
                      body: HTTPBody? = nil,
                      timeoutInterval: TimeInterval = 60) -> (any Request)? {
        guard URL(string: urlString) != nil else { return nil }
        return ConcreteRequest(
            httpMethod: httpMethod,
            urlString: urlString,
            parameters: parameters,
            headers: headers,
            body: body?.data,
            timeoutInterval: timeoutInterval
        )
    }
}
