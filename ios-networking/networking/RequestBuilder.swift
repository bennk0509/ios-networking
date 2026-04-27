//
//  RequestBuilder.swift
//  ios-networking
//
//  Created by Khanh Anh Kiet on 2026-04-25.
//

import Foundation

public protocol RequestBuildable{
    func build(httpMethod: HTTPMethod,
               urlString: String,
               parameters: [HTTPParameter]?,
               headers: [HTTPHeader]?,
               body: Data?,
               timeoutInterval: TimeInterval) -> URLRequest?
}


public class RequestBuilder: RequestBuildable{
    private let parameterEncoder: HTTPParameterEncoder
    private let headerEncoder: HTTPHeaderEncoder
    
    public init(parameterEncoder: HTTPParameterEncoder = HTTPParameterEncoderImpl(), headerEncoder: HTTPHeaderEncoder = HTTPHeaderEncoderImpl()) {
        self.parameterEncoder = parameterEncoder
        self.headerEncoder = headerEncoder
    }
    
    
    public func build(httpMethod: HTTPMethod, urlString: String, parameters: [HTTPParameter]?, headers: [HTTPHeader]?, body: Data?, timeoutInterval: TimeInterval) -> URLRequest? {
        
        guard let url = URL(string: urlString) else{
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.httpBody = body
        request.timeoutInterval = timeoutInterval
        
        if let parameters = parameters {
            try? parameterEncoder.encodeParameters(for: &request, with: parameters)
        }
        if let headers = headers{
            try? headerEncoder.encodeHeader(for: &request, with: headers)
        }
        return request
    }
}
