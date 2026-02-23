import SwiftUI
import DesignSystem
import PostDetailInterface

public struct LikesListView: View {
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
                    title: "Likes",
                    count: viewModel.likedPosts.count,
                    description: "좋아요 한 플레이리스트입니다."
                ) 

                if viewModel.likedPosts.isEmpty && !viewModel.isLoadingLikedPosts {
                    EmptyInboxListView(message: "좋아요한 사연이 없습니다")
                        .frame(maxWidth: .infinity)
                        .padding(.top, 60)
                } else {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(Array(viewModel.likedPosts.enumerated()), id: \.offset) { _, post in
                            if let postId = post.postId {
                                NavigationLink {
                                    postDetailBuilder.makePostDetailView(postId: postId, source: .feed)
                                } label: {
                                    MyPostCard(post: post, showsHeart: true)
                                }
                                .buttonStyle(.plain)
                            } else {
                                MyPostCard(post: post, showsHeart: true)
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
        .onAppear {
            viewModel.loadLikedPosts()
        }
    }
}
