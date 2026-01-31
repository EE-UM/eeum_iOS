//
//  LikeAPI.swift
//  EEUM-iOS
//
//  Created by 권민재 on 8/28/25.
//
import Foundation
import Moya

public enum LikeAPI {
    case getIsLike(postId: Int)
    case postLike(postId: Int)
    case deleteLike(postId: Int)
    case getLikeCount(postId: Int)
    case getUserLikes(userId: Int)
}

extension LikeAPI: TargetType, AccessTokenAuthorizable {
    public var authorizationType: AuthorizationType? {
        .bearer
    }

    public var baseURL: URL {
        Env.baseURL
    }

    public var path: String {
        switch self {
        case .getIsLike(let postId),
             .postLike(let postId),
             .deleteLike(let postId):
            return "/like/posts/\(postId)"
        case .getLikeCount(let postId):
            return "/like/count/\(postId)"
        case .getUserLikes(let userId):
            return "/like/users/\(userId)"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .getIsLike, .getLikeCount, .getUserLikes:
            return .get
        case .postLike:
            return .post
        case .deleteLike:
            return .delete
        }
    }

    public var task: Task {
        .requestPlain
    }

    public var headers: [String : String]? {
        [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
    }

    public var sampleData: Data { Data() }
}
