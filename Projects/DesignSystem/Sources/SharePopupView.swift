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
        GeometryReader { geometry in
            ZStack {
                // Dim
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture { isPresented = false }

                popup
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
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
            }
            .ignoresSafeArea(.keyboard)
        }
    }

    private var popup: some View {
        VStack(spacing: 0) {
            header

            content
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .padding(.bottom, 28)

            Spacer(minLength: 0)

            bottomBar
        }
        .frame(height: 410)
        .background(Color.mainBackground)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .contentShape(Rectangle())
        .padding(.horizontal, 40)
    }

    // MARK: - Header
    private var header: some View {
        VStack(spacing: 0) {
            Text("설정")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color.textPrimary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)

            Divider()
                .foregroundColor(Color.gray.opacity(0.15))
        }
    }

    // MARK: - Content
    private var content: some View {
        VStack(alignment: .leading, spacing: 28) {
            autoSection
            manualSection
        }
        .animation(.none, value: completionType)
    }

    private var isAutoSelected: Bool { completionType == .auto }

    private var autoSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            // 라디오 + 제목
            Button {
                completionType = .auto
            } label: {
                HStack(spacing: 12) {
                    RadioCircle(isSelected: isAutoSelected)
                    Text("플레이리스트 자동 완료")
                        .font(.system(size: 16, weight: isAutoSelected ? .semibold : .regular))
                        .foregroundColor(Color.textPrimary)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            // 설명
            Text("추가되는 댓글 및 음악 수를 설정하면\n자동으로 플레이리스트가 완료처리됩니다.")
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(Color.textFootnote)
                .lineSpacing(4)
                .padding(.leading, 34)

            // 최대 댓글 갯수 + pill dropdown
            HStack {
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
                    HStack(spacing: 8) {
                        Text("\(commentLimit)개")
                            .font(.system(size: 15, weight: .semibold))
                        Image(systemName: "triangle.fill")
                            .font(.system(size: 8, weight: .bold))
                            .rotationEffect(.degrees(180))
                    }
                    .foregroundColor(Color.textPrimary)
                    .padding(.horizontal, 16)
                    .frame(height: 36)
                    .background(Color.black.opacity(0.06))
                    .clipShape(Capsule())
                }
                .disabled(!isAutoSelected)
            }
            .padding(.leading, 34)
            .padding(.top, 4)
        }
        .opacity(isAutoSelected ? 1.0 : 0.45)
    }

    private var manualSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Button {
                completionType = .manual
            } label: {
                HStack(spacing: 12) {
                    RadioCircle(isSelected: !isAutoSelected)
                    Text("수동 완료 처리")
                        .font(.system(size: 16, weight: isAutoSelected ? .regular : .semibold))
                        .foregroundColor(Color.textPrimary)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            Text("inbox 내 작성한 사연에서 직접\n플레이리스트를 완료할 수 있습니다.")
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(Color.textFootnote)
                .lineSpacing(4)
                .padding(.leading, 34)
        }
        .opacity(isAutoSelected ? 0.45 : 1.0)
    }

    // MARK: - Bottom Bar
    private var bottomBar: some View {
        VStack(spacing: 0) {
            Divider()
                .foregroundColor(Color.gray.opacity(0.15))

            HStack(spacing: 0) {
                Button {
                    isPresented = false
                } label: {
                    Text("취소")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(Color.textPrimary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                }

                Divider()
                    .foregroundColor(Color.gray.opacity(0.15))
                    .frame(height: 24)

                Button {
                    onConfirm(completionType, commentLimit)
                    isPresented = false
                } label: {
                    Text("공유")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(Color.textPrimary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                }
            }
        }
    }
}

// MARK: - Radio UI
private struct RadioCircle: View {
    let isSelected: Bool

    var body: some View {
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
}

#Preview {
    SharePopupView(
        isPresented: .constant(true),
        onConfirm: { type, limit in
            print("Type:", type, "Limit:", limit)
        }
    )
}
