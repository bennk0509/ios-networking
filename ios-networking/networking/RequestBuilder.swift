//
//  RequestBuilder.swift
//  ios-networking
//
//  Created by Khanh Anh Kiet on 2026-04-30.
//
import Foundation

public protocol RequestBuilder {
    func setHttpMethod(_ method: HTTPMethod) -> RequestBuilder
    func setBaseUrl(_ baseUrl: String) -> RequestBuilder
    func setParameters(_ parameters: [HTTPParameter]) -> RequestBuilder
    func setHeaders(_ headers: [HTTPHeader]) -> RequestBuilder
    func setBody(_ body: HTTPBody) -> RequestBuilder
    func setTimeoutInterval(_ timeoutInterval: TimeInterval) -> RequestBuilder
    func build() -> Request?
}

public class RequestBuilderImpl: RequestBuilder {
    
    private struct ConcreteRequest: Request {
        let httpMethod: HTTPMethod
        let urlString: String
        let parameters: [HTTPParameter]?
        let headers: [HTTPHeader]?
        let body: Data?
        let timeoutInterval: TimeInterval?
    }
    
    private var httpMethod: HTTPMethod?
    private var baseUrlString: String?
    private var parameters: [HTTPParameter]?
    private var headers: [HTTPHeader]?
    private var body: HTTPBody?
    private var timeoutInterval: TimeInterval?

    private let headerEncoder: HTTPHeaderEncoder
    private let paramEncoder: HTTPParameterEncoder

    public init(headerEncoder: HTTPHeaderEncoder = HTTPHeaderEncoderImpl(),
                paramEncoder: HTTPParameterEncoder = HTTPParameterEncoderImpl()) {
        self.headerEncoder = headerEncoder
        self.paramEncoder = paramEncoder
    }

    public func setHttpMethod(_ method: HTTPMethod) -> RequestBuilder {
        self.httpMethod = method
        return self
    }

    public func setBaseUrl(_ baseUrl: String) -> RequestBuilder {
        self.baseUrlString = baseUrl
        return self
    }

    public func setParameters(_ parameters: [HTTPParameter]) -> RequestBuilder {
        self.parameters = parameters
        return self
    }

    public func setHeaders(_ headers: [HTTPHeader]) -> RequestBuilder {
        self.headers = headers
        return self
    }

    public func setBody(_ body: HTTPBody) -> RequestBuilder {
        self.body = body
        return self
    }

    public func setTimeoutInterval(_ timeoutInterval: TimeInterval) -> RequestBuilder {
        self.timeoutInterval = timeoutInterval
        return self
    }

    public func build() -> Request? {
        guard let httpMethod, let baseUrlString else { return nil }
        return ConcreteRequest(httpMethod: httpMethod, urlString: baseUrlString, parameters: parameters, headers: headers, body: body?.data, timeoutInterval: timeoutInterval)
    }
}
