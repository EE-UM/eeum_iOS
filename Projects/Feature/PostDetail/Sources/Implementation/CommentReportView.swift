import SwiftUI
import Domain
import DesignSystem
import UIKit

struct ClearBackgroundView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        Task { @MainActor in
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

struct CommentReportOverlay: View {
    let comment: Comment
    let isPlaying: Bool
    let onPlay: () -> Void
    let onReport: () -> Void
    let onDismiss: () -> Void

    var body: some View {
        ZStack {
            // 어두운 배경
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    onDismiss()
                }

            VStack(spacing: 0) {
                Spacer()

                // 댓글 카드
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 12) {
                        // 음악 아이콘
                        Image(systemName: "music.note")
                            .font(.system(size: 14))
                            .foregroundColor(.black)
                            .frame(width: 32, height: 32)
                            .background(Color.gray.opacity(0.1))
                            .clipShape(Circle())

                        // 곡 정보
                        VStack(alignment: .leading, spacing: 2) {
                            Text(comment.songName ?? "제목 없음")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.black)

                            Text(comment.artistName ?? "아티스트 미상")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }

                        Spacer()

                        // 재생 버튼
                        if comment.appleMusicUrl != nil && !(comment.appleMusicUrl?.isEmpty ?? true) {
                            Button(action: onPlay) {
                                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                                    .font(.system(size: 10))
                                    .foregroundColor(.black)
                                    .frame(width: 24, height: 24)
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(Color.black, lineWidth: 1)
                                    )
                            }
                        }
                    }

                    // 댓글 내용
                    if let content = comment.content, !content.isEmpty {
                        Text(content)
                            .font(.system(size: 14))
                            .foregroundColor(.black)
                            .lineSpacing(4)
                    }
                }
                .padding(16)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 4)
                .padding(.horizontal, 24)

                // 신고하기 버튼
                Button(action: onReport) {
                    Text("신고하기")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)
                .padding(.bottom, 50)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: comment.id)
    }
}

struct CommentReportSheet: View {
    let comment: Comment
    let isPlaying: Bool
    let onPlay: () -> Void
    let onReport: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            // 댓글 미리보기 카드
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 12) {
                    // 음악 아이콘
                    Image(systemName: "music.note")
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                        .frame(width: 32, height: 32)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(Circle())

                    // 곡 정보
                    HStack(spacing: 8) {
                        Text(comment.songName ?? "제목 없음")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.black)

                        Text(comment.artistName ?? "")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }

                    Spacer()

                    // 재생 버튼
                    if comment.appleMusicUrl != nil && !(comment.appleMusicUrl?.isEmpty ?? true) {
                        Button(action: onPlay) {
                            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                                .font(.system(size: 10))
                                .foregroundColor(.black)
                                .frame(width: 20, height: 20)
                                .background(Color.white)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Color.black, lineWidth: 1)
                                )
                        }
                    }
                }

                // 댓글 내용
                if let content = comment.content, !content.isEmpty {
                    Text(content)
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                        .lineSpacing(4)
                        .lineLimit(4)
                }
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)
            .padding(.horizontal, 24)
            .padding(.top, 24)

            Spacer()

            // 신고하기 버튼
            Button(action: onReport) {
                Text("신고하기")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .background(Color.black.opacity(0.4))
    }
}

struct ReportReasonView: View {
    @Environment(\.dismiss) private var dismiss
    let comment: Comment
    let onSubmit: (ReportReason, String?) -> Void

    @State private var selectedReason: ReportReason?
    @State private var customReason: String = ""
    @FocusState private var isCustomReasonFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            // 헤더
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image("home")
                        .foregroundColor(.black)
                }

                Spacer()

                Text("신고하기")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.black)

                Spacer()

                // 균형을 위한 투명 버튼
                Image("home")
                    .foregroundColor(.clear)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)

            // 질문
            Text("이 게시물을 신고하는 이유가 무엇인가요?")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.black)
                .padding(.top, 24)
                .padding(.horizontal, 20)

            // 신고 사유 목록
            VStack(alignment: .leading, spacing: 0) {
                ForEach(ReportReason.allCases, id: \.self) { reason in
                    Button {
                        selectedReason = reason
                        if reason == .other {
                            isCustomReasonFocused = true
                        } else {
                            submitReport(reason: reason)
                        }
                    } label: {
                        HStack {
                            if reason == .other {
                                Text("기타: ")
                                    .font(.system(size: 15))
                                    .foregroundColor(.black)
                                + Text("입력해주세요")
                                    .font(.system(size: 15))
                                    .foregroundColor(.gray)
                            } else {
                                Text(reason.displayText)
                                    .font(.system(size: 15))
                                    .foregroundColor(.black)
                            }

                            Spacer()
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 20)
                    }

                    if reason != ReportReason.allCases.last {
                        Divider()
                            .padding(.horizontal, 20)
                    }
                }
            }
            .padding(.top, 24)

            // 기타 입력 필드 (선택시)
            if selectedReason == .other {
                VStack(spacing: 12) {
                    TextField("신고 사유를 입력해주세요", text: $customReason)
                        .font(.system(size: 15))
                        .padding(12)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .focused($isCustomReasonFocused)

                    Button {
                        submitReport(reason: .other)
                    } label: {
                        Text("신고하기")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(customReason.isEmpty ? Color.gray : Color.black)
                            .cornerRadius(8)
                    }
                    .disabled(customReason.isEmpty)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }

            Spacer()
        }
        .background(Color.mainBackground)
    }

    private func submitReport(reason: ReportReason) {
        let customText = reason == .other ? customReason : nil
        onSubmit(reason, customText)
        dismiss()
    }
}

enum ReportReason: String, CaseIterable {
    case violence = "VIOLENCE"
    case sexual = "SEXUAL"
    case spam = "SPAM"
    case other = "OTHER"

    var displayText: String {
        switch self {
        case .violence:
            return "폭력 및 혐오 표현"
        case .sexual:
            return "성적 불쾌감을 일으키는 표현"
        case .spam:
            return "스팸 및 사기"
        case .other:
            return "기타"
        }
    }
}
