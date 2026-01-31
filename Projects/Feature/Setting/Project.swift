import ProjectDescription

let project = Project(
    name: "Setting",
    organizationName: "eeum",
    settings: .settings(defaultSettings: .recommended),
    targets: [
        .target(
            name: "SettingInterface",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "io.tuist.eeum.setting.interface",
            deploymentTargets: .iOS("18.0"),
            sources: ["Sources/Interface/**"],
            resources: []
        ),
        .target(
            name: "Setting",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "io.tuist.eeum.setting",
            deploymentTargets: .iOS("18.0"),
            sources: ["Sources/Implementation/**"],
            resources: [],
            dependencies: [
                .target(name: "SettingInterface"),
                .project(target: "Domain", path: "../../Domain"),
                .project(target: "DesignSystem", path: "../../DesignSystem"),
            ]
        ),
        .target(
            name: "SettingDemoApp",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.eeum.setting.demoapp",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["Sources/DemoApp/**"],
            resources: [],
            dependencies: [
                .target(name: "Setting"),
            ]
        ),
    ]
)
