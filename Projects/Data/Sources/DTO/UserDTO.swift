//
//  UserDTO.swift
//  Data
//
//  Created by 권민재 on 11/28/25.
//  Copyright © 2025 eeum. All rights reserved.
//
import Foundation
import Domain

public struct UserDTO: Decodable {
    public let accessToken: String
    public let tokenType: String
    public let role: String
    public let isRegistered: Bool


    public func toDomain() -> UserData {
        return UserData(
            accessToken: accessToken,
            tokenType: tokenType,
            role: role,
            isRegistered: isRegistered
        )
    }

}


