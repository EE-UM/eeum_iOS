//
//  LikeUseCase.swift
//  Domain
//
//  Created by Claude on 12/4/25.
//

import Foundation

public protocol LikeUseCase {
    func fetchIsLiked(postId: Int64) async throws -> Bool
    func like(postId: Int64) async throws
    func unlike(postId: Int64) async throws
    func fetchLikeCount(postId: Int64) async throws -> Int
}

public final class DefaultLikeUseCase: LikeUseCase {
    private let repository: LikeRepository

    public init(repository: LikeRepository) {
        self.repository = repository
    }

    public func fetchIsLiked(postId: Int64) async throws -> Bool {
        try await repository.fetchIsLiked(postId: postId)
    }

    public func like(postId: Int64) async throws {
        try await repository.like(postId: postId)
    }

    public func unlike(postId: Int64) async throws {
        try await repository.unlike(postId: postId)
    }

    public func fetchLikeCount(postId: Int64) async throws -> Int {
        try await repository.fetchLikeCount(postId: postId)
    }
}
