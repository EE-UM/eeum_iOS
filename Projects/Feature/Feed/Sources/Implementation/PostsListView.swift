import SwiftUI
import DesignSystem
import PostDetailInterface

public struct PostsListView: View {
    @ObservedObject var viewModel: FeedViewModel
    private let postDetailBuilder: PostDetailBuildable

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    public init(viewModel: FeedViewModel, postDetailBuilder: PostDetailBuildable) {
        _viewModel = ObservedObject(initialValue: viewModel)
        self.postDetailBuilder = postDetailBuilder
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                InboxHeaderView(
                    title: "Posts",
                    count: viewModel.myPosts.count,
                    description: "직접 공유한 사연과 플레이리스트입니다."
                )


                if viewModel.myPosts.isEmpty && !viewModel.isLoading {
                    EmptyInboxListView(message: "작성한 사연이 없습니다")
                        .frame(maxWidth: .infinity)
                        .padding(.top, 60)
                } else {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(Array(viewModel.myPosts.enumerated()), id: \.offset) { _, post in
                            if let postId = post.postId {
                                NavigationLink {
                                    postDetailBuilder.makePostDetailView(postId: postId)
                                } label: {
                                    MyPostCard(post: post)
                                }
                                .buttonStyle(.plain)
                            } else {
                                MyPostCard(post: post)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .background(Color.mainBackground)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: InboxMenuListView(viewModel: viewModel, postDetailBuilder: postDetailBuilder)) {
                    Image(systemName: "line.3.horizontal")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(Color.textPrimary)
                }
            }
        }
        .onAppear {
            if viewModel.myPosts.isEmpty {
                viewModel.loadMyPosts()
            }
        }
    }
}
