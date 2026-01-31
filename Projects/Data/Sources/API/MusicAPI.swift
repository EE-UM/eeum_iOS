//
//  MusicAPI.swift
//  EEUM-iOS
//
//  Created by 권민재 on 8/28/25.
//
import Foundation
import Moya

public enum MusicAPI {
    case search(term: String, types: String, limit: String)
}


extension MusicAPI: TargetType {
    public var baseURL: URL {
        return Env.baseURL
    }

    public var path: String {
        switch self {
        case .search:
            return "/apple-music/search"
        }
    }

    public var method: Moya.Method {
        return .get
    }

    public var task: Moya.Task {
        switch self {
        case let .search(term, types, limit):
            return .requestParameters(
                parameters: [
                    "term" : term,
                    "types" : types,
                    "limit" : limit

                ],encoding: URLEncoding.queryString)
        }
    }

    public var headers: [String : String]? {
        return [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }


}
