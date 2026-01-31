//
//  UserRepository.swift
//  Domain
//
//  Created by 권민재 on 11/28/25.
//  Copyright © 2025 eeum. All rights reserved.
//
import Foundation

public protocol UserRepository {
    func login(deviceId: String)
    func fetchProfile()
}
