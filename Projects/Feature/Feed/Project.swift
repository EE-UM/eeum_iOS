import ProjectDescription

let project = Project(
    name: "Feed",
    organizationName: "eeum",
    settings: .settings(defaultSettings: .recommended),
    targets: [
        .target(
            name: "FeedInterface",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "io.tuist.eeum.feed.interface",
            deploymentTargets: .iOS("18.0"),
            sources: ["Sources/Interface/**"],
            resources: [],
            dependencies: [
                .project(target: "ShareInterface", path: "../Share")
            ]
        ),
        .target(
            name: "Feed",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "io.tuist.eeum.feed",
            deploymentTargets: .iOS("18.0"),
            sources: ["Sources/Implementation/**"],
            resources: [],
            dependencies: [
                .target(name: "FeedInterface"),
                .project(target: "Domain", path: "../../Domain"),
                .project(target: "DesignSystem", path: "../../DesignSystem"),
                .project(target: "PostDetailInterface", path: "../PostDetail"),
                .project(target: "ShareInterface", path: "../Share"),
            ]
        ),
        .target(
            name: "FeedDemoApp",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.eeum.feed.demoapp",
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
                .target(name: "Feed"),
            ]
        ),
    ]
)
