//
//  PostRepository.swift
//  ios-networking
//
//  Created by Khanh Anh Kiet on 2026-04-25.
//

protocol PostRepositoryProtocol {
    func getPosts() async throws -> [Post]
}

class PostRepository: PostRepositoryProtocol {
    private let service: PostServiceProtocol
    private var posts: [Post] = []

    init(service: PostServiceProtocol = PostService()) {
        self.service = service
    }

    func getPosts() async throws -> [Post] {
        posts = try await service.fetchPosts()
        return posts
    }
}
