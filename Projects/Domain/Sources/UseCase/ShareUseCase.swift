//
//  ShareUseCase.swift
//  Domain
//
//  Created by 권민재 on 12/4/25.
//

import Foundation

public protocol ShareUseCase {
    func shareStory(
        title: String,
        description: String,
        story: String,
        musicTitle: String?,
        musicArtist: String?,
        musicAlbumName: String?,
        musicArtworkUrl: String?,
        musicPreviewUrl: String?,
        completionType: String,
        commentCountLimit: Int
    ) async throws
}

public final class DefaultShareUseCase: ShareUseCase {
    private let repository: PostRepository

    public init(repository: PostRepository) {
        self.repository = repository
    }

    public func shareStory(
        title: String,
        description: String,
        story: String,
        musicTitle: String?,
        musicArtist: String?,
        musicAlbumName: String?,
        musicArtworkUrl: String?,
        musicPreviewUrl: String?,
        completionType: String,
        commentCountLimit: Int
    ) async throws {
        let albumName = musicAlbumName ?? description
        let songName = musicTitle ?? ""
        let artistName = musicArtist ?? ""
        let artworkUrl = musicArtworkUrl ?? ""
        let previewUrl = musicPreviewUrl ?? ""

        try await repository.createPost(
            title: title,
            content: story,
            albumName: albumName,
            songName: songName,
            artistName: artistName,
            artworkUrl: artworkUrl,
            appleMusicUrl: previewUrl,
            completionType: completionType,
            commentCountLimit: commentCountLimit
        )
    }
}
