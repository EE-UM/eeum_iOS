//
//  Music.swift
//  EEUM-iOS
//
//  Created by 권민재 on 9/1/25.
//

public struct Music: Sendable {
    public let albumName: String
    public let songName: String
    public let artistName: String
    public let artworkUrl: String
    public let previewMusicUrl: String

    public init(
        albumName: String,
        songName: String,
        artistName: String,
        artworkUrl: String,
        previewMusicUrl: String
    ) {
        self.albumName = albumName
        self.songName = songName
        self.artistName = artistName
        self.artworkUrl = artworkUrl
        self.previewMusicUrl = previewMusicUrl
    }
}
extension Music: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(songName)
        hasher.combine(artistName)
        hasher.combine(albumName)
    }

    public static func == (lhs: Music, rhs: Music) -> Bool {
        lhs.songName == rhs.songName &&
        lhs.artistName == rhs.artistName &&
        lhs.albumName == rhs.albumName
    }
}

extension Music: Identifiable {
    public var id: String {
        "\(songName)-\(artistName)-\(albumName)"
    }
}
