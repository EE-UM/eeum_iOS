//
//  CommentAOI.swift
//  EEUM-iOS
//
//  Created by 권민재 on 8/28/25.
//

import Foundation
import Moya


public enum CommentAPI {
    case getComments(postId: Int)
    case postComment(content: String, albumName: String, songName: String, artistName: String, artworkUrl: String, appleMusicUrl: String, postId: Int)
    case updateComment(commentId: Int, content: String)
    case deleteComment(commentId: Int)

}

extension CommentAPI: TargetType, AccessTokenAuthorizable {
    public var authorizationType: AuthorizationType? {
        return .bearer
    }

    public var baseURL: URL {
        return Env.baseURL
    }

    public var path: String {
        switch self {
        case .getComments(let id):
            return "/comments/\(id)"
        case .deleteComment(let commentId):
            return "/comments/\(commentId)"
        case .updateComment(let commentId, _):
            return "/comments/\(commentId)"
        case .postComment:
            return "/comments"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .getComments:
            return .get
        case .postComment:
            return .post
        case .updateComment:
            return .put
        case .deleteComment:
            return .delete
        }
    }

    public var task: Moya.Task {
        switch self {
        case .getComments, .deleteComment:
            return .requestPlain
        case let .postComment(content, albumName, songName, artistName, artworkUrl, appleMusicUrl, postId):
            return .requestParameters(parameters: [
                "content" : content,
                "albumName" : albumName,
                "songName" : songName,
                "artistName" : artistName,
                "artworkUrl" : artworkUrl,
                "appleMusicUrl" : appleMusicUrl,
                "postId" : postId
            ], encoding: JSONEncoding.default)
        case let .updateComment(_, content):
            return .requestParameters(parameters: [
                "content" : content
            ], encoding: JSONEncoding.default)
        }
    }

    public var headers: [String : String]? {
        return [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }


}
