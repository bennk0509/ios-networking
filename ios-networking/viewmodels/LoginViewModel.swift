//
//  LoginViewModel.swift
//  ios-networking
//
//  Created by Khanh Anh Kiet on 2026-05-02.
//

import Foundation


@MainActor
class LoginViewModel {
    var isLoading = false
    var errorMessage: String?
    var isLoggedIn = false
            
    private let repository: AuthRepositoryProtocol

    init(repository: AuthRepositoryProtocol) {
      self.repository = repository
    }
              
    func login(email: String, password: String) async {
      isLoading = true
      errorMessage = nil
      defer { isLoading = false }
                                                                              
      do {
          try await repository.login(email: email, password: password)
          isLoggedIn = true
      } catch let error as NetworkingError {
          if case .httpError(let httpError) = error {
              print("❌ HTTP \(httpError.statusCode): \(httpError.description)")
              errorMessage = "HTTP \(httpError.statusCode): \(httpError.description)"
          } else {
              print("❌ Error: \(error)")
              errorMessage = "Login failed"
          }
      } catch {
          print("❌ Unknown: \(error)")
          errorMessage = "Login failed"
      }
    }
}
