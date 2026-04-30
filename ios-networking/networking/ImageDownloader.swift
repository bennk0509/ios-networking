//
//  ImageDownloader.swift
//  ios-networking
//
//  Created by Khanh Anh Kiet on 2026-04-30.
//
import Foundation
import UIKit


public protocol ImageDownloadable{
    func downloadImage(from url: URL) async throws -> UIImage
}



public struct ImageDownloader: ImageDownloadable{

    private let urlSession: URLSession
    private let urlResponseValidator: ResponseValidator

    public init(urlSession: URLSession, urlResponseValidator: ResponseValidator = ResponseValidatorImpl()) {
        self.urlSession = urlSession
        self.urlResponseValidator = urlResponseValidator
    }

    public func downloadImage(from url: URL) async throws -> UIImage {
        do {
            let (data, response) = try await urlSession.data(from: url, delegate: nil)
            try urlResponseValidator.validateStatus(from: response)
            let validData = try urlResponseValidator.validateData(data)
            guard let image = UIImage(data: validData) else {
                throw NetworkingError.internalError(.invalidImageData)
            }
            return image
        } catch let error as NetworkingError {
            throw error
        } catch {
            throw NetworkingError.internalError(.unknown)
        }
    }
}
