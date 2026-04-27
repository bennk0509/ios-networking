//
//  Post.swift
//  ios-networking
//
//  Created by Khanh Anh Kiet on 2026-04-25.
//

struct Post: Decodable, Hashable {
    let id: Int
    let title: String
    let body: String
}
