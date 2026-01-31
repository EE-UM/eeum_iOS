//
//  LoginUseCase.swift
//  Domain
//
//  Created by 권민재 on 11/28/25.
//  Copyright © 2025 eeum. All rights reserved.
//

import Foundation

public protocol LoginUseCase {
    func executeGuestLogin(deviceId: String)
}

public class DefaultLoginUseCase: LoginUseCase {
    private let userRepository: UserRepository

    public init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    public func executeGuestLogin(deviceId: String) {
        userRepository.login(deviceId: deviceId)
    }
}
