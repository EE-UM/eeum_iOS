import SwiftUI
import Domain

struct PostEditSheet: View {
    @ObservedObject var viewModel: PostDetailViewModel
    let detail: PostDetail
    @Environment(\.dismiss) private var dismiss

    @State private var title: String
    @State private var content: String
    @State private var isSaving: Bool = false
    @State private var errorMessage: String?

    init(viewModel: PostDetailViewModel, detail: PostDetail) {
        self.viewModel = viewModel
        self.detail = detail
        _title = State(initialValue: detail.title)
        _content = State(initialValue: detail.content)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("제목")) {
                    TextField("제목을 입력하세요", text: $title)
                }

                Section(header: Text("내용")) {
                    TextEditor(text: $content)
                        .frame(minHeight: 200)
                }

                if let errorMessage {
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundColor(.red)
                }
            }
            .navigationTitle("게시글 수정")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        Task { await saveChanges() }
                    } label: {
                        if isSaving {
                            ProgressView()
                        } else {
                            Text("저장")
                        }
                    }
                    .disabled(isSaving || title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }

    private func saveChanges() async {
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "제목을 입력해주세요."
            return
        }

        isSaving = true
        errorMessage = nil
        let success = await viewModel.updatePost(title: title, content: content)
        isSaving = false

        if success {
            dismiss()
        } else {
            errorMessage = "게시글을 수정하지 못했습니다. 다시 시도해주세요."
        }
    }
}
