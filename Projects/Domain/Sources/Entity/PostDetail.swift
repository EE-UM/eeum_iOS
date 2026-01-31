//
//  PostDetail.swift
//  EEUM-iOS
//
//  Created by 권민재 on 9/7/25.
//

import Foundation


public struct PostDetail {
    public let postId: String
    public let title: String
    public let content: String
    public let songName: String
    public let artistName: String
    public let artworkUrl: String
    public let appleMusicUrl: String
    public let createdAt: String
    public let isLiked: Bool
    public let comments: [Comment]?

    public init(
        postId: String,
        title: String,
        content: String,
        songName: String,
        artistName: String,
        artworkUrl: String,
        appleMusicUrl: String,
        createdAt: String,
        isLiked: Bool,
        comments: [Comment]? = nil
    ) {
        self.postId = postId
        self.title = title
        self.content = content
        self.songName = songName
        self.artistName = artistName
        self.artworkUrl = artworkUrl
        self.appleMusicUrl = appleMusicUrl
        self.createdAt = createdAt
        self.isLiked = isLiked
        self.comments = comments
    }
}

