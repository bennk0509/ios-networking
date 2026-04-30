//
//  Request.swift
//  ios-networking
//
//  Created by Khanh Anh Kiet on 2026-04-30.
//

import Foundation

public protocol Request{
    var httpMethod: HTTPMethod {get}
    var urlString: String {get}
    var parameters: [HTTPParameter]? {get}
    var headers: [HTTPHeader]? {get}
    var body: Data? {get}
   
}

public extension Request{
    var timeoutInterval: TimeInterval {60}
    
    func urlRequest() -> URLRequest? {
        guard let url = URL(string: urlString) else{
            return nil
        }
        
        var request = URLRequest(url:url)
        request.httpMethod = httpMethod.rawValue
        request.httpBody = body
        request.timeoutInterval = timeoutInterval
        
        if let parameters = parameters{
            try? HTTPParameterEncoderImpl().encodeParameters(for: &request, with: parameters)
        }
        if let headers = headers{
            try? HTTPHeaderEncoderImpl().encodeHeader(for: &request, with: headers)
        }
        
        return request
    }
}
