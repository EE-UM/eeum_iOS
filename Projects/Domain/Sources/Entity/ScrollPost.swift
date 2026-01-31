//
//  ScrollPost.swift
//  EEUM-iOS
//
//  Created by 권민재 on 9/1/25.
//

import Foundation


public struct ScrollPost {
    public let postId: String
    public let title: String
    public let content: String
    public let songName: String?
    public let artistName: String?
    public let artworkUrl: String?
    public let appleMusicUrl: String?
    public let createdAt: String
    public let isCompleted: Bool

    public init(
        postId: String,
        title: String,
        content: String,
        songName: String? = nil,
        artistName: String? = nil,
        artworkUrl: String? = nil,
        appleMusicUrl: String? = nil,
        createdAt: String,
        isCompleted: Bool
    ) {
        self.postId = postId
        self.title = title
        self.content = content
        self.songName = songName
        self.artistName = artistName
        self.artworkUrl = artworkUrl
        self.appleMusicUrl = appleMusicUrl
        self.createdAt = createdAt
        self.isCompleted = isCompleted
    }
}
