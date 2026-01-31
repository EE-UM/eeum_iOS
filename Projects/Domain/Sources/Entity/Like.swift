//
//  Like.swift
//  EEUM-iOS
//
//  Created by 권민재 on 9/1/25.
//

import Foundation


public struct Like {
    public let postId: String
    public let userId: String?
    public let isLiked: Bool?

    public init(
        postId: String,
        userId: String? = nil,
        isLiked: Bool? = nil
    ) {
        self.postId = postId
        self.userId = userId
        self.isLiked = isLiked
    }
}
