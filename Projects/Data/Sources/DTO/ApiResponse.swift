//
//  ApiResponse.swift
//  Data
//
//  Created by 권민재 on 11/26/25.
//  Copyright © 2025 eeum. All rights reserved.
//


import Foundation
import Domain


struct ApiResponse<T: Decodable>: Decodable {
    let result: String
    let data: T?
    let error: ApiError?
}

struct ApiError: Decodable {
    let code: String?
    let message: String?
    let data: [String: String]?
}

// MARK: - 포스트 모델 DTO
struct PostModelDTO: Codable {
    let postId: Int64?
    let writerId: Int64?
    let title: String?
    let content: String?
    let songName: String?
    let artistName: String?
    let artworkUrl: String?
    let appleMusicUrl: String?
    let createdAt: String?
    let isCompleted: Bool?
    
    func toEntity() -> Post {
        Post(
            postId: postId.map { String($0) },
            writerId: writerId.map { String($0) },
            title: title,
            content: content,
            songName: songName,
            artistName: artistName,
            artworkUrl: artworkUrl,
            appleMusicUrl: appleMusicUrl,
            createdAt: createdAt,
            isCompleted: isCompleted
        )
    }
}

// MARK: - 내가 쓴 글 리스트 DTO
struct MyPostsResponseDTO: Codable {
    let postCount: Int?
    let getMyPostResponses: [PostModelDTO]?

    func toEntities() -> [Post] {
        return getMyPostResponses?.map { $0.toEntity() } ?? []
    }
}

// MARK: - 무한 스크롤 포스트 DTO (Feed Ing/Done API용)
struct InfiniteScrollPostDTO: Codable {
    let postId: Int64  // ✅ API에서 숫자로 오므로 Int64
    let title: String
    let content: String
    let songName: String?
    let artistName: String?
    let artworkUrl: String?
    let appleMusicUrl: String?
    let createdAt: String
    let isCompleted: Bool

    func toEntity() -> Post {
        return Post(
            postId: String(postId),  // ✅ Int64를 String으로 변환
            writerId: nil,
            title: title,
            content: content,
            songName: songName,
            artistName: artistName,
            artworkUrl: artworkUrl,
            appleMusicUrl: appleMusicUrl,
            createdAt: createdAt,
            isCompleted: isCompleted
        )
    }
}

// MARK: - 랜덤 포스트 DTO (Random API용)
struct RandomPostDTO: Codable {
    let postId: Int64
    let writerId: Int64?
    let title: String
    let content: String

    func toEntity() -> Post {
        return Post(
            postId: String(postId),
            writerId: writerId.map { String($0) },
            title: title,
            content: content,
            songName: nil,
            artistName: nil,
            artworkUrl: nil,
            appleMusicUrl: nil,
            createdAt: nil,
            isCompleted: nil
        )
    }
}

// MARK: - 댓글 모델 DTO
struct CommentModelDTO: Codable {
    let commentId: Int64?
    let postId: Int64?
    let userId: Int64?
    let content: String?
    let createdAt: String?
    let albumName: String?
    let songName: String?
    let artistName: String?
    let artworkUrl: String?
    let appleMusicUrl: String?
    let modifiedAt: String?
    let isDeleted: Bool?



    func toEntity() -> Comment {
        return Comment(
            commentId: commentId.map { String($0) },
            postId: postId.map { String($0) },
            userId: userId.map { String($0) },
            content: content,
            createdAt: createdAt,
            albumName: albumName,
            songName: songName,
            artistName: artistName,
            artworkUrl: artworkUrl,
            appleMusicUrl: appleMusicUrl,
            modifiedAt: modifiedAt,
            isDeleted: isDeleted
        )
    }
}

// MARK: - 댓글한 포스트 DTO (Comments API용)
struct CommentedPostDTO: Codable {
    let postId: Int64  // ✅ API에서 숫자로 오므로 Int64
    let artworkUrl: String
    let title: String
    let createdAt: String
    let updatedAt: String
    
    func toEntity() -> Post {
        return Post(
            postId: String(postId),  // ✅ Int64를 String으로 변환
            writerId: nil,
            title: title,
            content: nil,
            songName: nil,
            artistName: nil,
            artworkUrl: artworkUrl,
            appleMusicUrl: nil,
            createdAt: createdAt,
            isCompleted: nil
        )
    }
}

// MARK: - 좋아요 모델 DTO
public struct LikeModelDTO: Codable {
    public let postId: String
    public let userId: String?
    public let isLiked: Bool?
    
    func toEntity() -> Like {
        return Like(
            postId: postId,
            userId: userId,
            isLiked: isLiked)
    }
}

// MARK: - 좋아요한 포스트 DTO (Likes API용)
public struct LikedPostDTO: Codable {
    public let postId: Int64
    public let artworkUrl: String?
    public let createdAt: String?
    public let updatedAt: String?
    public let title: String?
    public let content: String?
    public let songName: String?
    public let artistName: String?
    public let appleMusicUrl: String?
    
    func toEntity() -> Post {
        return Post(
            postId: String(postId),
            writerId: nil,
            title: title,
            content: content,
            songName: songName,
            artistName: artistName,
            artworkUrl: artworkUrl,
            appleMusicUrl: appleMusicUrl,
            createdAt: createdAt,
            isCompleted: nil
        )
    }
}


struct MusicDTO: Codable {
    let albumName: String
    let songName: String
    let artistName: String
    let artworkUrl: String
    let previewMusicUrl: String
    
    func toEntity() -> Music {
        return Music(
            albumName: albumName,
            songName: songName,
            artistName: artistName,
            artworkUrl: artworkUrl,
            previewMusicUrl: previewMusicUrl
        )
    }
}
