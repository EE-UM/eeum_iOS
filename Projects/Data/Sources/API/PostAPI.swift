//
//  PostAPI.swift
//  EEUM-iOS
//
//  Created by 권민재 on 8/28/25.
//

import Moya
import Foundation



public enum PostAPI {
    case createPost(title: String, content: String, albumName: String, songName: String, artistName: String, artworkUrl: String, appleMusicUrl: String, completionType: String, commentCountLimit: Int)
    case updatePost(postId: Int64, title: String, content: String)
    case updatePostState(postId: Int64)
    case getPostDetail(postId: Int64)
    case deletePost(postId: Int64)
    case getRandomPosts
    case getMyPosts
    case getLikedPosts(pageSize: Int64, lastPostId: Int64?)
    case getIngPosts(pageSize: Int64, lastPostId: Int64?)
    case getDonePosts(pageSize: Int64, lastPostId: Int64?)
    case getCommentedPosts
}

extension PostAPI: TargetType, AccessTokenAuthorizable {
    public var authorizationType: AuthorizationType? {
        return .bearer
    }

    public var baseURL: URL { Env.baseURL }

    public var path: String {
        switch self {
        case .createPost:                             return "/posts"
        case .updatePost(let id, _, _):               return "/posts/\(id)"
        case .updatePostState(let id):                return "/posts/\(id)/complete"
        case .getPostDetail(let id):                  return "/posts/\(id)"
        case .deletePost(let id):                     return "/posts/\(id)"
        case .getRandomPosts:                         return "/posts/random"
        case .getMyPosts:                             return "/posts/my"
        case .getLikedPosts:                          return "/posts/liked"
        case .getIngPosts:                            return "/posts/ing/infinite-scroll"
        case .getDonePosts:                           return "/posts/done/infinite-scroll"
        case .getCommentedPosts:                      return "/posts/commented"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .getRandomPosts, .getMyPosts, .getLikedPosts, .getIngPosts, .getDonePosts, .getCommentedPosts, .getPostDetail:
            return .get
        case .updatePostState, .updatePost:
            return .patch
        case .createPost:
            return .post
        case .deletePost:
            return .delete
        }
    }

    public var task: Task {
        switch self {
        case .getRandomPosts, .getMyPosts, .getCommentedPosts, .getPostDetail, .updatePostState, .deletePost:
            return .requestPlain

        case let .getDonePosts(pageSize, lastId):
            var params: [String: Any] = ["pageSize": pageSize]
            if let lastId { params["lastPostId"] = lastId }
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)

        case let .getLikedPosts(pageSize, lastId):
            var params: [String: Any] = ["pageSize": pageSize]
            if let lastId { params["lastPostId"] = lastId }
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString) // ← 쿼리

        case let .getIngPosts(pageSize, lastId):
            var params: [String: Any] = ["pageSize": pageSize]
            if let lastId { params["lastPostId"] = lastId }
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)

        case let .createPost(title, content, albumName, songName, artistName, artworkUrl, appleMusicUrl, completionType, commentCountLimit):
            let body: [String: Any] = [
                "title": title,
                "content": content,
                "albumName": albumName,
                "songName": songName,
                "artistName": artistName,
                "artworkUrl": artworkUrl,
                "appleMusicUrl": appleMusicUrl,
                "completionType": completionType,
                "commentCountLimit": commentCountLimit
            ]
            return .requestParameters(parameters: body, encoding: JSONEncoding.default)      // ← JSON body

        case let .updatePost(_, title, content):
            let body = ["title": title, "content": content]
            return .requestParameters(parameters: body, encoding: JSONEncoding.default)      // ← JSON body
        }
    }

    public var headers: [String : String]? {
        ["Accept": "application/json", "Content-Type": "application/json"]
    }

    public var sampleData: Data { Data() }
}
