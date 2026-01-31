//
//  LikeRepositoryImpl.swift
//  Data
//
//  Created by Claude on 12/4/25.
//

import Foundation
import Domain
import Moya

public final class LikeRepositoryImpl: LikeRepository {
    private let provider: MoyaProvider<LikeAPI>
    private let decoder: JSONDecoder

    public init(provider: MoyaProvider<LikeAPI>, decoder: JSONDecoder = .init()) {
        self.provider = provider
        self.decoder = decoder
    }

    public func fetchIsLiked(postId: Int64) async throws -> Bool {
        let response = try await provider.asyncRequest(.getIsLike(postId: Int(postId)))
        let filtered = try response.filterSuccessfulStatusCodes()
        let apiResponse = try decoder.decode(ApiResponse<LikeModelDTO>.self, from: filtered.data)
        guard
            let dto = apiResponse.data,
            let isLiked = dto.isLiked
        else {
            throw NSError(domain: "LikeRepository", code: -1, userInfo: [NSLocalizedDescriptionKey: "Like status not found"])
        }
        return isLiked
    }

    public func like(postId: Int64) async throws {
        let response = try await provider.asyncRequest(.postLike(postId: Int(postId)))
        _ = try response.filterSuccessfulStatusCodes()
    }

    public func unlike(postId: Int64) async throws {
        let response = try await provider.asyncRequest(.deleteLike(postId: Int(postId)))
        _ = try response.filterSuccessfulStatusCodes()
    }

    public func fetchLikeCount(postId: Int64) async throws -> Int {
        let response = try await provider.asyncRequest(.getLikeCount(postId: Int(postId)))
        let filtered = try response.filterSuccessfulStatusCodes()
        let apiResponse = try decoder.decode(ApiResponse<Int>.self, from: filtered.data)
        return apiResponse.data ?? 0
    }
}
