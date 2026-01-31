//
//  LikeRepository.swift
//  Domain
//
//  Created by Claude on 12/4/25.
//

import Foundation

public protocol LikeRepository {
    func fetchIsLiked(postId: Int64) async throws -> Bool
    func like(postId: Int64) async throws
    func unlike(postId: Int64) async throws
    func fetchLikeCount(postId: Int64) async throws -> Int
}
