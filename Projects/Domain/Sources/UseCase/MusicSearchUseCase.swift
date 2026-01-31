//
//  MusicSearchUseCase.swift
//  Domain
//
//  Created by 권민재 on 11/28/25.
//  Copyright © 2025 eeum. All rights reserved.
//

import Foundation

public protocol MusicSearchUseCase {
    func searchMusic(query: String) async throws -> [Music]
}

public class DefaultMusicSearchUseCase: MusicSearchUseCase {
    private let musicRepository: MusicRepository

    public init(musicRepository: MusicRepository) {
        self.musicRepository = musicRepository
    }

    public func searchMusic(query: String) async throws -> [Music] {
        return try await musicRepository.searchMusic(query: query)
    }
}
