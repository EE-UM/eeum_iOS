//
//  ENV.swift
//  EEUM-iOS
//
//  Created by 권민재 on 8/28/25.
//
import Foundation

enum Env {
    static let baseURL: URL = {
        #if DEBUG
        let s = "https://eeum.xyz/dev"
        #else
        let s = "https://eeum.xyz"
        #endif

        guard let url = URL(string: s) else {
            preconditionFailure("❌ BaseURL 문자열이 URL 형식이 아님: \(s)")
        }
        return url
    }()
}
