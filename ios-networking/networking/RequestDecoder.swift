//
//  RequestDecoder.swift
//  ios-networking
//
//  Created by Khanh Anh Kiet on 2026-04-25.
//

import Foundation

// FROM JSON -> T
public protocol RequestDecodable{
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
}

public struct RequestDecoder: RequestDecodable{
    
    public init(){}
    
    public func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        do{
            return try JSONDecoder().decode(type, from: data)
        } catch{
            throw NetworkingError.internalError(.couldNotParse)
        }
    }
    
    
}
