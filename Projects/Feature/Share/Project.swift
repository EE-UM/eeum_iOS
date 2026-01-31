import ProjectDescription

let project = Project(
    name: "Share",
    organizationName: "eeum",
    settings: .settings(defaultSettings: .recommended),
    targets: [
        .target(
            name: "ShareInterface",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "io.tuist.eeum.share.interface",
            deploymentTargets: .iOS("18.0"),
            sources: ["Sources/Interface/**"],
            resources: [],
            dependencies: [
                .project(target: "Domain", path: "../../Domain")
            ],
            settings: .settings(base: [
                "SWIFT_INSTALL_OBJC_HEADER": "YES"
            ])
        ),
        .target(
            name: "Share",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "io.tuist.eeum.share",
            deploymentTargets: .iOS("18.0"),
            sources: ["Sources/Implementation/**"],
            resources: [],
            dependencies: [
                .target(name: "ShareInterface"),
                .project(target: "Domain", path: "../../Domain"),
                .project(target: "DesignSystem", path: "../../DesignSystem"),
            ],
            settings: .settings(base: [
                "SWIFT_INSTALL_OBJC_HEADER": "YES"
            ])
        ),
        .target(
            name: "ShareDemoApp",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.eeum.share.demoapp",
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
                .target(name: "Share"),
            ]
        ),
    ]
)
