//
//  LoginAPI.swift
//  EEUM-iOS
//
//  Created by 권민재 on 8/28/25.
//

import Foundation
import Moya


public enum LoginAPI {
    case login(idToken: String, provider: String)
    case guestLogin(deviceId: String, provider: String)
}


extension LoginAPI: TargetType {
    public var baseURL: URL {
        return Env.baseURL
    }
    
    public var path: String {
        switch self {
        case .login:
            return "/user/login"
        case .guestLogin:
            return "/user/guest"
        }
    }
    
    public var method: Moya.Method {
        return .post
    }
    
    public var task: Moya.Task {
        switch self {
        case let .login(idToken, provider):
            return .requestParameters(parameters: ["idToken": idToken, "provider": provider], encoding: JSONEncoding.default)
        case let .guestLogin(deviceId, provider):
            return .requestParameters(parameters: ["deviceId": deviceId, "provider": provider], encoding: JSONEncoding.default)
        }
    }
    
    public var headers: [String : String]? {
        return [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }
    
    
}
