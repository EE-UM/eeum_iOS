//
//  UserData.swift
//  EEUM-iOS
//
//  Created by 권민재 on 9/1/25.
//

import Foundation


public struct UserData {
    public let accessToken: String
    public let tokenType: String
    public let role: String
    public let isRegistered: Bool

    public init(
        accessToken: String,
        tokenType: String,
        role: String,
        isRegistered: Bool
    ) {
        self.accessToken = accessToken
        self.tokenType = tokenType
        self.role = role
        self.isRegistered = isRegistered
    }
}
