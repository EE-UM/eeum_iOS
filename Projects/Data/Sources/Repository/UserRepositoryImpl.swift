//
//  LoginRepository.swift
//  Data
//
//  Created by 권민재 on 11/28/25.
//  Copyright © 2025 eeum. All rights reserved.
//

import Foundation
import Domain
import Moya

public class UserRepositoryImpl: UserRepository {
    private let provider: MoyaProvider<LoginAPI>

    public init(provider: MoyaProvider<LoginAPI>) {
        self.provider = provider
    }

    public func login(deviceId: String) {
        provider.request(.guestLogin(deviceId: deviceId, provider: "GUEST")) { result in
            switch result {
            case .success(let response):
                do {
                    let apiResponse = try JSONDecoder().decode(ApiResponse<UserDTO>.self, from: response.data)
                    if let userData = apiResponse.data {
                        let user = userData.toDomain()
                        // accessToken 저장
                        UserDefaults.standard.set(user.accessToken, forKey: "accessToken")
                        print("✅ 게스트 로그인 성공: \(user.accessToken)")
                    }
                } catch {
                    print("❌ 로그인 응답 파싱 실패: \(error)")
                }
            case .failure(let error):
                print("❌ 로그인 API 호출 실패: \(error)")
            }
        }
    }

    public func fetchProfile() {
        // TODO: 프로필 조회 구현
    }
}
