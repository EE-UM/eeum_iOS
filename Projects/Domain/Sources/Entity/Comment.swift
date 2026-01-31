//
//  Comment.swift
//  EEUM-iOS
//
//  Created by 권민재 on 9/1/25.
//

import Foundation

public struct Comment {
    public let commentId: String?
    public let postId: String?
    public let userId: String?
    public let content: String?
    public let createdAt: String?
    public let albumName: String?
    public let songName: String?
    public let artistName: String?
    public let artworkUrl: String?
    public let appleMusicUrl: String?
    public let modifiedAt: String?
    public let isDeleted: Bool?

    public init(
        commentId: String? = nil,
        postId: String? = nil,
        userId: String? = nil,
        content: String? = nil,
        createdAt: String? = nil,
        albumName: String? = nil,
        songName: String? = nil,
        artistName: String? = nil,
        artworkUrl: String? = nil,
        appleMusicUrl: String? = nil,
        modifiedAt: String? = nil,
        isDeleted: Bool? = nil
    ) {
        self.commentId = commentId
        self.postId = postId
        self.userId = userId
        self.content = content
        self.createdAt = createdAt
        self.albumName = albumName
        self.songName = songName
        self.artistName = artistName
        self.artworkUrl = artworkUrl
        self.appleMusicUrl = appleMusicUrl
        self.modifiedAt = modifiedAt
        self.isDeleted = isDeleted
    }
}
