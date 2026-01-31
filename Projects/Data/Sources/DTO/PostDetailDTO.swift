//
//  PostDetailDTO.swift
//  Data
//
//  Created by 권민재 on 11/28/25.
//  Copyright © 2025 eeum. All rights reserved.
//
import Foundation
import Domain

struct PostDetailDTO: Codable {
    let postId: Int64
    let title: String
    let content: String
    let songName: String
    let artistName: String
    let artworkUrl: String
    let appleMusicUrl: String
    let createdAt: String
    let isLiked: Bool
    let comments: [CommentModelDTO]

    func toEntity() -> PostDetail {
        let toEntitiedComments = comments.map { $0.toEntity() }
        return PostDetail(
            postId: String(postId),
            title: title,
            content: content,
            songName: songName,
            artistName: artistName,
            artworkUrl: artworkUrl,
            appleMusicUrl: appleMusicUrl,
            createdAt: createdAt,
            isLiked: isLiked,
            comments: toEntitiedComments)
    }
}
