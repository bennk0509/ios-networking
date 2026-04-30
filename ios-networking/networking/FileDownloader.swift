//
//  FileDownloader.swift
//  ios-networking
//
//  Created by Khanh Anh Kiet on 2026-04-30.
//
import Foundation

public protocol FileDownloadable{
    func downloadFile(with url: URL) async throws -> URL
}

public struct FileDownloader: FileDownloadable{

    private let urlSession: URLSession
    private let urlResponseValidator: ResponseValidator

    public init(urlSession: URLSession, urlResponseValidator: ResponseValidator = ResponseValidatorImpl()) {
        self.urlSession = urlSession
        self.urlResponseValidator = urlResponseValidator
    }

    public func downloadFile(with url: URL) async throws -> URL {
        do {
            let (fileURL, urlResponse) = try await urlSession.download(from: url, delegate: nil)
            try urlResponseValidator.validateStatus(from: urlResponse)
            return try urlResponseValidator.validateUrl(fileURL)
        } catch let error as NetworkingError {
            throw error
        } catch {
            throw NetworkingError.internalError(.unknown)
        }
    }
}

