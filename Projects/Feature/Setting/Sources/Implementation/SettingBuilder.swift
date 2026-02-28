import SwiftUI
import SettingInterface
import DesignSystem

public struct SettingBuilder: SettingBuildable {

    public init() {}

    public func makeSettingView() -> AnyView {
        AnyView(SettingView())
    }
}

private struct SettingView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL

    var body: some View {
        VStack(spacing: 0) {
            settingRow(title: "FAQ") {
                if let url = URL(string: "https://www.notion.so/220a8ad06b41800886aedbe718fa6c3c") {
                    openURL(url)
                }
            }

            settingRow(title: "Contacts us") {
                if let url = URL(string: "mailto:eeum.app@gmail.com") {
                    openURL(url)
                }
            }

            settingRow(title: "Terms of services") {
                if let url = URL(string: "https://www.notion.so/220a8ad06b41800886aedbe718fa6c3c") {
                    openURL(url)
                }
            }

            settingRow(title: "Privacy Policy") {
                if let url = URL(string: "https://www.notion.so/220a8ad06b41800886aedbe718fa6c3c") {
                    openURL(url)
                }
            }

            Spacer()
        }
        .padding(.top, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.mainBackground)
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.textPrimary)
                }
            }
        }
    }

    @ViewBuilder
    private func settingRow(title: String, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            HStack {
                Text(title)
                    .font(.pretendard(size: 16, weight: .medium))
                    .foregroundColor(.textPrimary)

                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 18)
        }
        .buttonStyle(.plain)
    }

}
