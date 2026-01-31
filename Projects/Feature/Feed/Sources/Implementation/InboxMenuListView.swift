//
//  InboxMenuListView.swift
//  Feed
//
//  Created by 권민재 on 12/2/25.
//  Copyright © 2025 eeum. All rights reserved.
//
import SwiftUI
import PostDetailInterface

enum InboxMenuItem: CaseIterable, Identifiable {
    case posts
    case comments
    case likes

    var id: String { title }

    var title: String {
        switch self {
        case .posts: return "Posts"
        case .comments: return "Comments"
        case .likes: return "Likes"
        }
    }

    var description: String {
        switch self {
        case .posts:
            return "작성 공유된 사연이 표시됩니다."
        case .comments:
            return "댓글을 남긴 사연이 표시됩니다."
        case .likes:
            return "좋아요한 사연이 표시됩니다."
        }
    }

    var emptyMessage: String {
        switch self {
        case .posts:
            return "작성한 사연이 없습니다"
        case .comments:
            return "댓글을 남긴 사연이 없습니다"
        case .likes:
            return "좋아요한 사연이 없습니다"
        }
    }
}

public struct InboxMenuListView: View {
    @ObservedObject private var viewModel: FeedViewModel
    private let postDetailBuilder: PostDetailBuildable
    private let menuItems = InboxMenuItem.allCases

    public init(viewModel: FeedViewModel, postDetailBuilder: PostDetailBuildable) {
        _viewModel = ObservedObject(initialValue: viewModel)
        self.postDetailBuilder = postDetailBuilder
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(menuItems) { item in
                NavigationLink(destination: destinationView(for: item)) {
                    Text(item.title)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 12)
                }
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .background(Color.mainBackground)
        .navigationTitle("menu")
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private func destinationView(for item: InboxMenuItem) -> some View {
        switch item {
        case .posts:
            PostsListView(viewModel: viewModel, postDetailBuilder: postDetailBuilder)
        case .comments:
            CommentsListView(viewModel: viewModel, postDetailBuilder: postDetailBuilder)
        case .likes:
            LikesListView(viewModel: viewModel, postDetailBuilder: postDetailBuilder)
        }
    }
}
