//
//  MusicRepositoryImpl.swift
//  Data
//
//  Created by 권민재 on 11/28/25.
//  Copyright © 2025 eeum. All rights reserved.
//

import Foundation
import Domain
import Moya

public class MusicRepositoryImpl: MusicRepository {
    private let provider: MoyaProvider<MusicAPI>

    public init(provider: MoyaProvider<MusicAPI>) {
        self.provider = provider
    }

    public func searchMusic(query: String) async throws -> [Music] {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(.search(term: query, types: "songs", limit: "20")) { result in
                switch result {
                case .success(let response):
                    do {
                        let apiResponse = try JSONDecoder().decode(ApiResponse<[MusicDTO]>.self, from: response.data)
                        if let musics = apiResponse.data {
                            let musicList = musics.map { $0.toEntity() }
                            continuation.resume(returning: musicList)
                        } else {
                            continuation.resume(returning: [])
                        }
                    } catch {
                        print("❌ 음악 검색 응답 파싱 실패: \(error)")
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    print("❌ 음악 검색 API 호출 실패: \(error)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
