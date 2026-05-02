//
//  AuthRepository.swift
//  ios-networking
//
//  Created by Khanh Anh Kiet on 2026-05-02.
//

import Foundation

protocol AuthRepositoryProtocol {
    func login(email: String, password: String) async throws
}


class AuthRepository: AuthRepositoryProtocol{
    
    private let authService: AuthNetworkService
    private let sessionManager: SessionManager
    
    
    init(authService: AuthNetworkService, sessionManager: SessionManager) {
        self.authService = authService
        self.sessionManager = sessionManager
    }
    
    func login(email: String, password: String) async throws {
        let response = try await authService.login(email: email, password: password)
        sessionManager.storeToken(response.token)
    }
    
    
}
