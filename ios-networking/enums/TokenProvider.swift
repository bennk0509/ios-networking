//
//  TokenProvider.swift
//  ios-networking
//
//  Created by Khanh Anh Kiet on 2026-05-02.
//

public protocol TokenProvider {
    func accessToken() async throws -> String
    func refreshToken() async throws
}
