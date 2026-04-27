//
//  URLResponseValidator 2.swift
//  ios-networking
//
//  Created by Khanh Anh Kiet on 2026-04-25.
//

import Foundation


public protocol URLResponseValidator {
    func validate(data: Data?, urlResponse: URLResponse?, error: Error?) throws -> Data
    
}

public struct URLResponseValidatorImpl: URLResponseValidator{
    public init(){}
    public func validate(data: Data?, urlResponse: URLResponse?, error: (any Error)?) throws -> Data {
        guard let data = data else{
            throw NetworkingError.noData
        }
        
        guard let urlResponse = urlResponse else{
            throw NetworkingError.noResponse
        }
        
        if let error = error{
            throw NetworkingError.requestFailed(error)
        }
        
        guard let httpURLResponse = urlResponse as? HTTPURLResponse else {
            throw NetworkingError.noHTTPURLResponse
        }
        
        guard (200...299).contains(httpURLResponse.statusCode) else {
              throw NetworkingError.from(statusCode: httpURLResponse.statusCode)
          }
        return data
    }
}
