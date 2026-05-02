//
//  AuthService.swift
//  ios-networking
//
//  Created by Khanh Anh Kiet on 2026-05-02.
//

import Foundation

class SessionManager: TokenProvider{
    
    private var currentToken: String =  ""
    
    func accessToken() async throws -> String {
        return currentToken
    }
    
    func refreshToken() async throws {}
    
    
    func storeToken(_ token: String) {
        currentToken = token
    }
    
}
