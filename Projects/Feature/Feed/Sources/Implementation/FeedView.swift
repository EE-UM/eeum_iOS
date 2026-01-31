import SwiftUI
import DesignSystem
import PostDetailInterface
import ShareInterface

struct FeedView: View {
    @StateObject var viewModel: FeedViewModel
    let postDetailBuilder: PostDetailBuildable
    let shareBuilder: any ShareBuildable
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.mainBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                FeedTabSelector(viewModel: viewModel)
                    .padding(.top, 20)

                Group {
                    if viewModel.selectedTab == .ing {
                        IngCardStackView(
                            posts: $viewModel.ingPosts,
                            currentPostId: $viewModel.currentCardPostId,
                            postDetailBuilder: postDetailBuilder,
                            onSwipe: {
                                viewModel.swipeToNextCard()
                            }
                        )
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.top, 12)
                    } else {
                        DoneGridView(
                            posts: viewModel.donePosts,
                            postDetailBuilder: postDetailBuilder,
                            onLoadMore: {
                                viewModel.loadDonePosts()
                            }
                        )
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .animation(.easeInOut(duration: 0.2), value: viewModel.selectedTab)
            }
        }
        .onAppear {
            if viewModel.ingPosts.isEmpty && viewModel.donePosts.isEmpty {
                viewModel.loadIngPosts()
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image("home")
                        .font(.system(size: 20))
                        .foregroundColor(Color.textPrimary)
                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: PostsListView(viewModel: viewModel, postDetailBuilder: postDetailBuilder)) {
                    HStack(spacing: 4) {
                        Text("Inbox")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(Color.textPrimary)
                        Image(systemName: "arrow.up.right")
                            .font(.system(size: 13))
                            .foregroundColor(Color.textPrimary)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.contentBackground)
                    .cornerRadius(20)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
}

private struct FeedTabSelector: View {
    @ObservedObject var viewModel: FeedViewModel

    var body: some View {
        HStack(spacing: 0) {
            TabButton(
                title: "Ing",
                isSelected: viewModel.selectedTab == .ing,
                action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        viewModel.selectedTab = .ing
                    }
                    if viewModel.ingPosts.isEmpty {
                        viewModel.loadIngPosts()
                    }
                }
            )

            TabButton(
                title: "Done",
                isSelected: viewModel.selectedTab == .done,
                action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        viewModel.selectedTab = .done
                    }
                    if viewModel.donePosts.isEmpty {
                        viewModel.loadDonePosts()
                    }
                }
            )

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 8)
    }
}

private struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(title)
                    .font(.system(size: 18, weight: isSelected ? .bold : .medium))
                    .foregroundColor(isSelected ? Color.textPrimary : Color.textFootnote)
            }
        }
        .frame(width: 80)
    }
}
