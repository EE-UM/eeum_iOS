import ProjectDescription

let project = Project(
    name: "Home",
    organizationName: "eeum",
    settings: .settings(defaultSettings: .recommended),
    targets: [
        .target(
            name: "HomeInterface",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "io.tuist.eeum.home.interface",
            deploymentTargets: .iOS("18.0"),
            sources: ["Sources/Interface/**"],
            resources: []
        ),
        .target(
            name: "Home",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "io.tuist.eeum.home",
            deploymentTargets: .iOS("18.0"),
            sources: ["Sources/Implementation/**"],
            resources: [],
            dependencies: [
                .target(name: "HomeInterface"),
                .project(target: "Domain", path: "../../Domain"),
                .project(target: "DesignSystem", path: "../../DesignSystem"),
                .project(target: "PostDetailInterface", path: "../PostDetail"),
            ]
        ),
        .target(
            name: "HomeDemoApp",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.eeum.home.demoapp",
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
                .target(name: "Home"),
            ]
        ),
    ]
)
