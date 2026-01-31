import ProjectDescription

let project = Project(
    name: "FeatureFactory",
    organizationName: "eeum",
    settings: .settings(defaultSettings: .recommended),
    targets: [
        .target(
            name: "FeatureFactory",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "io.tuist.eeum.feature.factory",
            deploymentTargets: .iOS("18.0"),
            sources: ["Sources/**"],
            resources: [],
            dependencies: [
                .project(target: "Domain", path: "../../Domain"),
                .project(target: "HomeInterface", path: "../Home"),
                .project(target: "Home", path: "../Home"),
                .project(target: "FeedInterface", path: "../Feed"),
                .project(target: "Feed", path: "../Feed"),
                .project(target: "ShareInterface", path: "../Share"),
                .project(target: "Share", path: "../Share"),
                .project(target: "Search", path: "../Search"),
                .project(target: "SettingInterface", path: "../Setting"),
                .project(target: "Setting", path: "../Setting"),
                .project(target: "AuthInterface", path: "../Auth"),
                .project(target: "Auth", path: "../Auth"),
                .project(target: "PostDetailInterface", path: "../PostDetail"),
                .project(target: "PostDetail", path: "../PostDetail"),
            ]
        ),
    ]
)
