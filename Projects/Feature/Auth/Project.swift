import ProjectDescription

let project = Project(
    name: "Auth",
    organizationName: "eeum",
    settings: .settings(defaultSettings: .recommended),
    targets: [
        .target(
            name: "AuthInterface",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "io.tuist.eeum.auth.interface",
            deploymentTargets: .iOS("18.0"),
            sources: ["Sources/Interface/**"],
            resources: []
        ),
        .target(
            name: "Auth",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "io.tuist.eeum.auth",
            deploymentTargets: .iOS("18.0"),
            sources: ["Sources/Implementation/**"],
            resources: [],
            dependencies: [
                .target(name: "AuthInterface"),
                .project(target: "Domain", path: "../../Domain"),
                .project(target: "DesignSystem", path: "../../DesignSystem"),
            ]
        ),
        .target(
            name: "AuthDemoApp",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.eeum.auth.demoapp",
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
                .target(name: "Auth"),
            ]
        ),
    ]
)
