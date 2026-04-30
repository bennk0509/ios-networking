//
//  HTTPBody.swift
//  ios-networking
//
//  Created by Khanh Anh Kiet on 2026-04-30.
//
import Foundation

public enum HTTPBody{
    case string(_ str: String)
    case dictionary(_ dic: [String: Any])
    case encodable(_ encodable: Encodable)
    case data(_ data: Data)
    case fileURL(_ url: URL)
    case jsonString(_ json: String)
    case base64(_ base64String: String)
    case urlComponents(_ components: URLComponents)

    var data: Data? {
        switch self {
        case .string(let str):
            return str.data(using: .utf8)
        case .dictionary(let dic):
            return try? JSONSerialization.data(withJSONObject: dic)
        case .encodable(let encodable):
            struct AnyEncodable: Encodable {
                let wrapped: any Encodable
                func encode(to encoder: Encoder) throws { try wrapped.encode(to: encoder) }
            }
            return try? JSONEncoder().encode(AnyEncodable(wrapped: encodable))
        case .data(let data):
            return data
        case .fileURL(let url):
            return try? Data(contentsOf: url)
        case .jsonString(let json):
            return json.data(using: .utf8)
        case .base64(let base64String):
            return Data(base64Encoded: base64String)
        case .urlComponents(let components):
            return components.query?.data(using: .utf8)
        }
    }
}
