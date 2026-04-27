//
//  HTTPHeaderEncoder.swift
//  ios-networking
//
//  Created by Khanh Anh Kiet on 2026-04-25.
//

import Foundation

public protocol HTTPHeaderEncoder{
    func encodeHeader(for urlRequest: inout URLRequest, with headers: [HTTPHeader]) throws
}

public struct HTTPHeaderEncoderImpl: HTTPHeaderEncoder{
    public init(){}
    public func encodeHeader(for urlRequest: inout URLRequest, with headers: [HTTPHeader]) throws {
        for header in headers {
            urlRequest.setValue(header.value, forHTTPHeaderField: header.key)
        }
    }
}

