import ProjectDescription

let project = Project(
    name: "Search",
    organizationName: "eeum",
    settings: .settings(defaultSettings: .recommended),
    targets: [
        .target(
            name: "Search",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "io.tuist.eeum.search",
            deploymentTargets: .iOS("18.0"),
            sources: [
                "Sources/Interface/**",
                "Sources/Implementation/**"
            ],
            resources: [],
            dependencies: [
                .project(target: "Domain", path: "../../Domain"),
                .project(target: "DesignSystem", path: "../../DesignSystem"),
            ]
        ),
        .target(
            name: "SearchDemoApp",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.eeum.search.demoapp",
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
                .target(name: "Search"),
            ]
        ),
    ]
)
