//
//  PostViewModel.swift
//  ios-networking
//
//  Created by Khanh Anh Kiet on 2026-04-25.
//


public class PostViewModel {
    
    private let repository: PostRepositoryProtocol
    private var allPosts: [Post] = []
    init(repository: PostRepositoryProtocol = PostRepository()) {
        self.repository = repository
    }

    func loadInitial() async -> [Post]{
        do {
            allPosts = try await repository.getPosts()
        } catch{
            print()
        }
        return allPosts
    }
    
    func getPosts() -> [Post]{
        return allPosts
    }

}
