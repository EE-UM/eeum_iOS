//
//  CommentRepository.swift
//  Domain
//
//  Created by Claude on 11/30/25.
//

import Foundation

public protocol CommentRepository {
    // Create
    func createComment(
        postId: Int64,
        content: String,
        albumName: String,
        songName: String,
        artistName: String,
        artworkUrl: String,
        appleMusicUrl: String
    ) async throws

    // Read
    func getComments(postId: Int64) async throws -> [Comment]

    // Update
    func updateComment(commentId: Int64, content: String) async throws

    // Delete
    func deleteComment(commentId: Int64) async throws
}
