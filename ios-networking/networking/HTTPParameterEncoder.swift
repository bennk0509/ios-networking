//
//  HTTPParam.swift
//  ios-networking
//
//  Created by Khanh Anh Kiet on 2026-04-25.
//

import Foundation

public protocol HTTPParameterEncoder{
    func encodeParameters(for urlRequest: inout URLRequest, with parameters: [HTTPParameter] ) throws
}


public struct HTTPParameterEncoderImpl: HTTPParameterEncoder{
    public init(){}
    
    
    public func encodeParameters(for urlRequest: inout URLRequest, with parameters: [HTTPParameter]) throws {
        guard let url = urlRequest.url else{
            throw NetworkingError.internalError(.noURL)
        }
        
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            urlComponents.queryItems = [URLQueryItem]()
            for parameter in parameters {
                let queryItem = URLQueryItem(name: parameter.key, value: parameter.value)
                urlComponents.queryItems?.append(queryItem)
            }
            //guard for the below
            urlRequest.url = urlComponents.url
        }
    }
}
