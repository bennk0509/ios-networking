//
//  PostService.swift
//  ios-networking
//
//  Created by Khanh Anh Kiet on 2026-04-25.
//

protocol PostServiceProtocol{
    func fetchPosts() async throws -> [Post]
}


public class PostService: PostServiceProtocol{
    private let builder: RequestFactory
    private let performer: AsyncRequestPerformable
    
    init(builder: RequestFactory = RequestFactoryImpl(),
         performer: AsyncRequestPerformable = AsyncRequestPerformer()
      ) {
        self.builder = builder
        self.performer = performer
    }
    
    func fetchPosts() async throws -> [Post]{
        guard let request = builder.build(httpMethod: .GET, urlString: "https://jsonplaceholder.typicode.com/posts", parameters: nil, headers: nil, body: nil, timeoutInterval: 30) else{
            throw NetworkingError.internalError(.noRequest)
        }
        return try await performer.perform(request: request,decodeTo: [Post].self)
    }
    
}
