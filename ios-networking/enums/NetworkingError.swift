//
//  NetworkingError.swift
//  ios-networking
//
//  Created by Khanh Anh Kiet on 2026-04-25.
//

import Foundation

public enum NetworkingError: Error {
    case unknown
    case noURL
    case noRequest
    case noData
    case noResponse
    case noHTTPURLResponse
    case couldNotParse
    case invalidImageData
    case requestFailed(Error)
    case http(HTTPStatusError)

    static func from(statusCode: Int) -> NetworkingError {
        HTTPStatusError(rawValue: statusCode).map { .http($0) } ?? .unknown
    }
}

public enum HTTPStatusError: Int {
    // 3xx Redirection
    case multipleChoices      = 300
    case movedPermanently     = 301
    case found                = 302
    case seeOther             = 303
    case notModified          = 304
    case temporaryRedirect    = 307
    case permanentRedirect    = 308

    // 4xx Client Errors
    case badRequest           = 400
    case unauthorized         = 401
    case paymentRequired      = 402
    case forbidden            = 403
    case notFound             = 404
    case methodNotAllowed     = 405
    case notAcceptable        = 406
    case requestTimeout       = 408
    case conflict             = 409
    case gone                 = 410
    case unprocessableEntity  = 422
    case tooManyRequests      = 429

    // 5xx Server Errors
    case internalServerError  = 500
    case notImplemented       = 501
    case badGateway           = 502
    case serviceUnavailable   = 503
    case gatewayTimeout       = 504
}
