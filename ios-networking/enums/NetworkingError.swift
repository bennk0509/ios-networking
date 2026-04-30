//
//  NetworkingError.swift
//  ios-networking
//
//  Created by Khanh Anh Kiet on 2026-04-25.
//

import Foundation

public enum NetworkingError: Error {
    case internalError(InternalError)
    case httpError(HTTPError)
    case urlError(URLError)
}

// MARK: - Internal Error

public enum InternalError: Error {
    case noURL
    case noRequest
    case noData
    case noResponse
    case noHTTPURLResponse
    case couldNotParse
    case invalidImageData
    case requestFailed(Error)
    case unknown
}

// MARK: - HTTP Error

public struct HTTPError: Error {
    public let statusCode: Int
    public let headers: [AnyHashable: Any]
    public let category: HTTPErrorCategory

    public init(statusCode: Int, headers: [AnyHashable: Any] = [:]) {
        self.statusCode = statusCode
        self.headers = headers
        self.category = HTTPErrorCategory.from(statusCode: statusCode)
    }

    public var description: String {
        switch category {
        case .informational: return HTTPInformationalStatus.description(from: statusCode)
        case .success:       return HTTPSuccessStatus.description(from: statusCode)
        case .redirection:   return HTTPRedirectionStatus.description(from: statusCode)
        case .clientError:   return HTTPClientErrorStatus.description(from: statusCode)
        case .serverError:   return HTTPServerErrorStatus.description(from: statusCode)
        case .unknown:       return "Unknown Status Code (\(statusCode))"
        }
    }

    public enum HTTPErrorCategory {
        case informational
        case success
        case redirection
        case clientError
        case serverError
        case unknown

        static func from(statusCode: Int) -> HTTPErrorCategory {
            switch statusCode {
            case 100...199: return .informational
            case 200...299: return .success
            case 300...399: return .redirection
            case 400...499: return .clientError
            case 500...599: return .serverError
            default:        return .unknown
            }
        }
    }
}

// MARK: - HTTP Status Descriptions

enum HTTPInformationalStatus {
    static func description(from statusCode: Int) -> String {
        descriptions[statusCode] ?? "Unknown Informational Status"
    }
    private static let descriptions: [Int: String] = [
        100: "Continue",
        101: "Switching Protocols",
        102: "Processing"
    ]
}

enum HTTPSuccessStatus {
    static func description(from statusCode: Int) -> String {
        descriptions[statusCode] ?? "Unknown Success Status"
    }
    private static let descriptions: [Int: String] = [
        200: "OK",
        201: "Created",
        202: "Accepted",
        203: "Non-Authoritative Information",
        204: "No Content",
        205: "Reset Content",
        206: "Partial Content",
        207: "Multi-Status",
        208: "Already Reported",
        226: "IM Used"
    ]
}

enum HTTPRedirectionStatus {
    static func description(from statusCode: Int) -> String {
        descriptions[statusCode] ?? "Unknown Redirection Status"
    }
    private static let descriptions: [Int: String] = [
        300: "Multiple Choices",
        301: "Moved Permanently",
        302: "Found",
        303: "See Other",
        304: "Not Modified",
        305: "Use Proxy",
        307: "Temporary Redirect",
        308: "Permanent Redirect"
    ]
}

enum HTTPClientErrorStatus {
    static func description(from statusCode: Int) -> String {
        descriptions[statusCode] ?? "Unknown Client Error"
    }
    private static let descriptions: [Int: String] = [
        400: "Bad Request",
        401: "Unauthorized",
        402: "Payment Required",
        403: "Forbidden",
        404: "Not Found",
        405: "Method Not Allowed",
        406: "Not Acceptable",
        407: "Proxy Authentication Required",
        408: "Request Timeout",
        409: "Conflict",
        410: "Gone",
        411: "Length Required",
        412: "Precondition Failed",
        413: "Payload Too Large",
        414: "URI Too Long",
        415: "Unsupported Media Type",
        416: "Range Not Satisfiable",
        417: "Expectation Failed",
        418: "I'm a teapot",
        421: "Misdirected Request",
        422: "Unprocessable Entity",
        423: "Locked",
        424: "Failed Dependency",
        425: "Too Early",
        426: "Upgrade Required",
        428: "Precondition Required",
        429: "Too Many Requests",
        431: "Request Header Fields Too Large",
        451: "Unavailable For Legal Reasons"
    ]
}

enum HTTPServerErrorStatus {
    static func description(from statusCode: Int) -> String {
        descriptions[statusCode] ?? "Unknown Server Error"
    }
    private static let descriptions: [Int: String] = [
        500: "Internal Server Error",
        501: "Not Implemented",
        502: "Bad Gateway",
        503: "Service Unavailable",
        504: "Gateway Timeout",
        505: "HTTP Version Not Supported",
        506: "Variant Also Negotiates",
        507: "Insufficient Storage",
        508: "Loop Detected",
        510: "Not Extended",
        511: "Network Authentication Required"
    ]
}
