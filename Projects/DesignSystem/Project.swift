import ProjectDescription

let project = Project(
    name: "DesignSystem",
    organizationName: "eeum",
    settings: .settings(defaultSettings: .recommended),
    targets: [
        .target(
            name: "DesignSystem",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "io.tuist.eeum.designsystem",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .extendingDefault(
                with: [
                    "UIAppFonts": .array([
                        "Fonts/Pretendard-Thin.otf",
                        "Fonts/Pretendard-ExtraLight.otf",
                        "Fonts/Pretendard-Light.otf",
                        "Fonts/Pretendard-Regular.otf",
                        "Fonts/Pretendard-Medium.otf",
                        "Fonts/Pretendard-SemiBold.otf",
                        "Fonts/Pretendard-Bold.otf",
                        "Fonts/Pretendard-ExtraBold.otf",
                        "Fonts/Pretendard-Black.otf",
                        "Fonts/Helvetica.ttf",
                        "Fonts/Helvetica-Bold.ttf"
                    ])
                ]
            ),
            sources: ["Sources/**"],
            resources: ["Resources/**"]
        ),
    ]
)
