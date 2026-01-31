//
//  Post.swift
//  EEUM-iOS
//
//  Created by 권민재 on 9/1/25.
//

import Foundation


public struct Post {
    public let postId: String?
    public let writerId: String?
    public let title: String?
    public let content: String?
    public let songName: String?
    public let artistName: String?
    public let artworkUrl: String?
    public let appleMusicUrl: String?
    public let createdAt: String?
    public let isCompleted: Bool?

    public init(
        postId: String? = nil,
        writerId: String? = nil,
        title: String? = nil,
        content: String? = nil,
        songName: String? = nil,
        artistName: String? = nil,
        artworkUrl: String? = nil,
        appleMusicUrl: String? = nil,
        createdAt: String? = nil,
        isCompleted: Bool? = nil
    ) {
        self.postId = postId
        self.writerId = writerId
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

