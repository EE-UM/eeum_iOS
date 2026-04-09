import SwiftUI
import Domain
import DesignSystem

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
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.black)
                }

                Spacer()

                Text("신고하기")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.black)

                Spacer()

                // 균형을 위한 투명 요소
                Color.clear
                    .frame(width: 18, height: 18)
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
        .onTapGesture {
            isCustomReasonFocused = false
        }
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
