//
//  ShareRepositoryImpl.swift
//  Data
//
//  Created by 권민재 on 12/4/25.
//

import Foundation
import Domain
import Moya

public final class PostRepositoryImpl: PostRepository {

    private let provider: MoyaProvider<PostAPI>
    private let decoder: JSONDecoder

    public init(provider: MoyaProvider<PostAPI>, decoder: JSONDecoder = .init()) {
        self.provider = provider
        self.decoder = decoder
    }

    // MARK: - Create / Update (Void 반환)
    public func createPost(title: String, content: String,
                    albumName: String, songName: String, artistName: String,
                    artworkUrl: String, appleMusicUrl: String,
                    completionType: String, commentCountLimit: Int) async throws {
        let res = try await provider.asyncRequest(.createPost(title: title, content: content,
                                                              albumName: albumName, songName: songName, artistName: artistName,
                                                              artworkUrl: artworkUrl, appleMusicUrl: appleMusicUrl,
                                                              completionType: completionType, commentCountLimit: commentCountLimit))
        _ = try res.filterSuccessfulStatusCodes()
    }

    public func updatePost(postId: Int64, title: String, content: String) async throws {
        let res = try await provider.asyncRequest(.updatePost(postId: postId, title: title, content: content))
        _ = try res.filterSuccessfulStatusCodes()
    }

    public func updatePostState(postId: Int64) async throws {
        let res = try await provider.asyncRequest(.updatePostState(postId: postId))
        _ = try res.filterSuccessfulStatusCodes()
    }

    // MARK: - Read
    public func getPostDetail(postId: Int64) async throws -> PostDetail {
        let res = try await provider.asyncRequest(.getPostDetail(postId: postId))
        let ok = try res.filterSuccessfulStatusCodes()
        let apiResponse = try decoder.decode(ApiResponse<PostDetailDTO>.self, from: ok.data)
        guard let dto = apiResponse.data else {
            throw NSError(domain: "PostRepository", code: -1, userInfo: [NSLocalizedDescriptionKey: "No post data found"])
        }
        return dto.toEntity()
    }

    public func getRandomPosts() async throws -> [Post] {
        let res = try await provider.asyncRequest(.getRandomPosts)
        let ok = try res.filterSuccessfulStatusCodes()

        // RandomPostDTO로 단일 포스트 디코딩
        let apiResponse = try decoder.decode(ApiResponse<RandomPostDTO>.self, from: ok.data)
        if let dto = apiResponse.data {
            return [dto.toEntity()]
        }

        return []
    }

    public func getMyPosts() async throws -> [Post] {
        let res = try await provider.asyncRequest(.getMyPosts)
        let ok = try res.filterSuccessfulStatusCodes()
        let apiResponse = try decoder.decode(ApiResponse<MyPostsResponseDTO>.self, from: ok.data)
        let dto = apiResponse.data
        return dto?.toEntities() ?? []
    }

    public func getLikedPosts() async throws -> [Post] {
        let res = try await provider.asyncRequest(.getLikedPosts(pageSize: 20, lastPostId: nil))  // ✅ 기본값 사용
        let ok = try res.filterSuccessfulStatusCodes()
        let apiResponse = try decoder.decode(ApiResponse<[LikedPostDTO]>.self, from: ok.data)  // ✅ LikedPostDTO 사용
        let dtos = apiResponse.data ?? []
        return dtos.map { $0.toEntity() }
    }

    public func getIngPosts(pageSize: Int64, lastPostId: Int64?) async throws -> [Post] {
        let res = try await provider.asyncRequest(.getIngPosts(pageSize: pageSize, lastPostId: lastPostId))
        let ok = try res.filterSuccessfulStatusCodes()
        let apiResponse = try decoder.decode(ApiResponse<[InfiniteScrollPostDTO]>.self, from: ok.data)
        let dtos = apiResponse.data ?? []
        return dtos.map { $0.toEntity() }
    }

    public func getDonePosts(pageSize: Int64, lastPostId: Int64?) async throws -> [Post] {
        let res = try await provider.asyncRequest(.getDonePosts(pageSize: pageSize, lastPostId: lastPostId))
        let ok = try res.filterSuccessfulStatusCodes()
        let apiResponse = try decoder.decode(ApiResponse<[InfiniteScrollPostDTO]>.self, from: ok.data)
        let dtos = apiResponse.data ?? []
        return dtos.map { $0.toEntity() }
    }

    public func getCommentedPosts() async throws -> [Post] {
        let res = try await provider.asyncRequest(.getCommentedPosts)
        let ok = try res.filterSuccessfulStatusCodes()
        let apiResponse = try decoder.decode(ApiResponse<[CommentedPostDTO]>.self, from: ok.data)  // ✅ CommentedPostDTO 사용
        let dtos = apiResponse.data ?? []
        return dtos.map { $0.toEntity() }
    }

    // MARK: - Delete
    public func deletePost(postId: Int64) async throws {
        let res = try await provider.asyncRequest(.deletePost(postId: postId))
        _ = try res.filterSuccessfulStatusCodes()
    }
}
