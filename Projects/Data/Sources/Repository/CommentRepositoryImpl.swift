//
//  CommentRepositoryImpl.swift
//  Data
//
//  Created by Claude on 11/30/25.
//

import Foundation
import Domain
import Moya

public final class CommentRepositoryImpl: CommentRepository {

    private let provider: MoyaProvider<CommentAPI>
    private let decoder: JSONDecoder

    public init(provider: MoyaProvider<CommentAPI>, decoder: JSONDecoder = .init()) {
        self.provider = provider
        self.decoder = decoder
    }

    // MARK: - Create
    public func createComment(
        postId: Int64,
        content: String,
        albumName: String,
        songName: String,
        artistName: String,
        artworkUrl: String,
        appleMusicUrl: String
    ) async throws {
        let res = try await provider.asyncRequest(
            .postComment(
                content: content,
                albumName: albumName,
                songName: songName,
                artistName: artistName,
                artworkUrl: artworkUrl,
                appleMusicUrl: appleMusicUrl,
                postId: Int(postId)
            )
        )
        _ = try res.filterSuccessfulStatusCodes()
    }

    // MARK: - Read
    public func getComments(postId: Int64) async throws -> [Comment] {
        let res = try await provider.asyncRequest(.getComments(postId: Int(postId)))
        let ok = try res.filterSuccessfulStatusCodes()
        let apiResponse = try decoder.decode(ApiResponse<[CommentModelDTO]>.self, from: ok.data)
        guard let dtos = apiResponse.data else {
            throw NSError(domain: "CommentRepository", code: -1, userInfo: [NSLocalizedDescriptionKey: "No comments found"])
        }
        return dtos.map { $0.toEntity() }
    }

    // MARK: - Update
    public func updateComment(commentId: Int64, content: String) async throws {
        let res = try await provider.asyncRequest(.updateComment(commentId: Int(commentId), content: content))
        _ = try res.filterSuccessfulStatusCodes()
    }

    // MARK: - Delete
    public func deleteComment(commentId: Int64) async throws {
        let res = try await provider.asyncRequest(.deleteComment(commentId: Int(commentId)))
        _ = try res.filterSuccessfulStatusCodes()
    }
}
