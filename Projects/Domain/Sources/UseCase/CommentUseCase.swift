//
//  CommentUseCase.swift
//  Domain
//
//  Created by Claude on 11/30/25.
//

import Foundation

public protocol CommentUseCase {
    func createComment(
        postId: Int64,
        content: String,
        albumName: String,
        songName: String,
        artistName: String,
        artworkUrl: String,
        appleMusicUrl: String
    ) async throws

    func getComments(postId: Int64) async throws -> [Comment]
    func updateComment(commentId: Int64, content: String) async throws
    func deleteComment(commentId: Int64) async throws
}

public final class DefaultCommentUseCase: CommentUseCase {
    private let repository: CommentRepository

    public init(repository: CommentRepository) {
        self.repository = repository
    }

    public func createComment(
        postId: Int64,
        content: String,
        albumName: String,
        songName: String,
        artistName: String,
        artworkUrl: String,
        appleMusicUrl: String
    ) async throws {
        try await repository.createComment(
            postId: postId,
            content: content,
            albumName: albumName,
            songName: songName,
            artistName: artistName,
            artworkUrl: artworkUrl,
            appleMusicUrl: appleMusicUrl
        )
    }

    public func getComments(postId: Int64) async throws -> [Comment] {
        return try await repository.getComments(postId: postId)
    }

    public func updateComment(commentId: Int64, content: String) async throws {
        try await repository.updateComment(commentId: commentId, content: content)
    }

    public func deleteComment(commentId: Int64) async throws {
        try await repository.deleteComment(commentId: commentId)
    }
}
