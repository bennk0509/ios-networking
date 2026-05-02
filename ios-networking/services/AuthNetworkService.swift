//
//  AuthNetworkService.swift
//  ios-networking
//
//  Created by Khanh Anh Kiet on 2026-05-02.
//

protocol AuthNetworkService{
    func login(email: String, password: String) async throws -> LoginResponse
}


class AuthNetworkServiceImpl: AuthNetworkService{
    
    private let requestFactory: RequestFactory
    private let performer: AsyncRequestPerformable
    
    init(requestFactory: RequestFactory, performer: AsyncRequestPerformable) {
        self.requestFactory = requestFactory
        self.performer = performer
    }
    
    
    func login(email: String, password: String) async throws -> LoginResponse {
        let body = HTTPBody.encodable(LoginRequest(email: email, password: password))
        print("Body data: \(String(data: body.data ?? Data(), encoding: .utf8) ?? "nil")")

        guard let request = requestFactory.build(
              httpMethod: .POST,
              urlString: "https://reqres.in/api/login",
              parameters: nil,
              headers: [.contentType(.json)],
              body: body,
              timeoutInterval: 30
        ) else{
            throw NetworkingError.internalError(.noRequest)
        }

        return try await performer.perform(request: request, decodeTo: LoginResponse.self)
        
        
        
    }
}
