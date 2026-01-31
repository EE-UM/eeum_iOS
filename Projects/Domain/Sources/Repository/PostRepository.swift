//
//  ShareRepository.swift
//  Domain
//
//  Created by 권민재 on 12/4/25.
//

import Foundation

public protocol PostRepository {
   
    func createPost(title: String, content: String,
                    albumName: String, songName: String, artistName: String,
                    artworkUrl: String, appleMusicUrl: String,
                    completionType: String, commentCountLimit: Int) async throws

    func updatePost(postId: Int64, title: String, content: String) async throws
    func updatePostState(postId: Int64) async throws

    
    func getPostDetail(postId: Int64) async throws -> PostDetail
    func getRandomPosts() async throws -> [Post]
    func getMyPosts() async throws -> [Post]
    func getLikedPosts() async throws -> [Post]  // ✅ 페이지네이션 없음
    func getIngPosts(pageSize: Int64, lastPostId: Int64?) async throws -> [Post]
    func getDonePosts(pageSize: Int64, lastPostId: Int64?) async throws -> [Post]
    func getCommentedPosts() async throws -> [Post]

    
    func deletePost(postId: Int64) async throws
}
