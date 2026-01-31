import SwiftUI
import SettingInterface
import Domain

public struct SettingBuilder: SettingBuildable {

    public init() {}

    public func makeSettingView() -> AnyView {
        AnyView(SettingView())
    }
}

private struct SettingView: View {

    var body: some View {
        Form {
            Section(header: Text("Account")) {
                SettingRow(title: "Status", subtitle: "Active")
                SettingRow(title: "Notifications", subtitle: "Enabled")
            }
            Section(header: Text("About")) {
                SettingRow(title: "Version", subtitle: "1.0.0")
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color(.systemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

private struct SettingRow: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.body)
            Text(subtitle)
                .font(.footnote)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}
