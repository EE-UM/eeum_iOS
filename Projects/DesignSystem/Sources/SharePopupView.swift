//
//  SharePopupView.swift
//  DesignSystem
//
//  Created by 권민재 on 11/29/25.
//  Copyright © 2025 eeum. All rights reserved.
//

import SwiftUI

public enum CompletionType {
    case auto
    case manual

    public var apiValue: String {
        switch self {
        case .auto:
            return "AUTO_COMPLETION"
        case .manual:
            return "MANUAL_COMPLETION"
        }
    }

    public var requiresCommentLimit: Bool {
        self == .auto
    }
}

public struct SharePopupView: View {
    @State private var completionType: CompletionType = .auto   // 스샷은 auto가 선택 상태
    @State private var commentLimit: Int = 20
    @State private var offset: CGSize = .zero
    @State private var isDragging: Bool = false

    @Binding var isPresented: Bool
    let onConfirm: (CompletionType, Int) -> Void

    private let commentLimitOptions = [10, 20, 30, 50, 100]

    public init(
        isPresented: Binding<Bool>,
        onConfirm: @escaping (CompletionType, Int) -> Void
    ) {
        self._isPresented = isPresented
        self.onConfirm = onConfirm
    }

    public var body: some View {
        ZStack {
            // Dim
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture { isPresented = false }

            popup
                .offset(y: offset.height)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if value.translation.height > 0 {
                                offset = value.translation
                                isDragging = true
                            }
                        }
                        .onEnded { value in
                            let threshold: CGFloat = 100
                            if value.translation.height > threshold {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    isPresented = false
                                }
                            } else {
                                withAnimation(.spring()) {
                                    offset = .zero
                                    isDragging = false
                                }
                            }
                        }
                )
                .animation(isDragging ? nil : .spring(response: 0.4, dampingFraction: 0.8), value: offset)
                .onTapGesture { } // 팝업 탭 시 배경 dismiss 방지
        }
    }

    private var popup: some View {
        VStack(spacing: 0) {
            header

            content
                .padding(.horizontal, 20)
                .padding(.top, 22)
                .padding(.bottom, 26)

            bottomBar
        }
        .frame(height: 410)
        .padding(.horizontal, 30)
        .background(Color.mainBackground)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    // MARK: - Header
    private var header: some View {
        VStack(spacing: 16) {
            Text("설정")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color.textPrimary)
                .padding(.top, 22)

            Divider()
                .opacity(0.15)
        }
    }

    // MARK: - Content
    private var content: some View {
        VStack(alignment: .leading, spacing: 28) {
            autoSection
            manualSection
        }
    }

    private var autoSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            // 라디오 + 제목
            HStack(alignment: .top, spacing: 12) {
                RadioCircle(isSelected: completionType == .auto) {
                    completionType = .auto
                }
                Text("플레이리스트 자동 완료")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color.textPrimary)
                    .padding(.top, 1)
            }

            // 설명 (라디오만큼 들여쓰기)
            Text("추가되는 댓글 및 음악 수를 설정하면\n자동으로 플레이리스트가 완료처리됩니다.")
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(Color.textFootnote)
                .lineSpacing(4)
                .padding(.leading, 32)

            // 최대 댓글 갯수 + pill dropdown
            HStack(spacing: 12) {
                Text("최대 댓글 갯수")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color.textPrimary)

                Spacer()

                Menu {
                    ForEach(commentLimitOptions, id: \.self) { limit in
                        Button("\(limit)개") {
                            commentLimit = limit
                        }
                    }
                } label: {
                    HStack(spacing: 10) {
                        Text("\(commentLimit)개")
                            .font(.system(size: 16, weight: .semibold))
                        Image(systemName: "triangle.fill")
                            .font(.system(size: 10, weight: .bold))
                            .rotationEffect(.degrees(180)) // ▼
                            .offset(y: 1)
                    }
                    .foregroundColor(Color.textPrimary)
                    .padding(.horizontal, 16)
                    .frame(height: 40)
                    .background(Color.black.opacity(0.06))
                    .clipShape(Capsule())
                }
            }
            .padding(.leading, 32)
        }
    }

    private var manualSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 12) {
                RadioCircle(isSelected: completionType == .manual) {
                    completionType = .manual
                }

                Text("수동 완료 처리")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(completionType == .manual ? Color.textPrimary : Color.gray.opacity(0.7))
                    .padding(.top, 1)
            }

            Text("inbox 내 작성한 사연에서 직접\n플레이리스트를 완료할 수 있습니다.")
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(completionType == .manual ? Color.textFootnote : Color.gray.opacity(0.55))
                .lineSpacing(4)
                .padding(.leading, 32)
        }
        .opacity(completionType == .manual ? 1.0 : 0.45)
    }

    // MARK: - Bottom Bar
    private var bottomBar: some View {
        VStack(spacing: 0) {
            Divider().opacity(0.15)

            HStack(spacing: 0) {
                Button {
                    isPresented = false
                } label: {
                    Text("취소")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color.textPrimary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }

                Divider()
                    .opacity(0.15)

                Button {
                    onConfirm(completionType, commentLimit)
                    isPresented = false
                } label: {
                    Text("공유")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color.textPrimary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .frame(height: 72)
        }
    }
}

// MARK: - Radio UI
private struct RadioCircle: View {
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStack {
                Circle()
                    .stroke(isSelected ? Color.black : Color.gray.opacity(0.35), lineWidth: 2)
                    .frame(width: 22, height: 22)

                if isSelected {
                    Circle()
                        .fill(Color.black)
                        .frame(width: 12, height: 12)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SharePopupView(
        isPresented: .constant(true),
        onConfirm: { type, limit in
            print("Type:", type, "Limit:", limit)
        }
    )
}
