import ProjectDescription

let project = Project(
    name: "Coordinator",
    organizationName: "eeum",
    settings: .settings(defaultSettings: .recommended),
    targets: [
        .target(
            name: "Coordinator",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "io.tuist.eeum.coordinator",
            deploymentTargets: .iOS("18.0"),
            sources: ["Sources/**"],
            resources: [],
            dependencies: [
                .project(target: "Domain", path: "../Domain"),
                .project(target: "ShareInterface", path: "../Feature/Share"),
                .project(target: "PostDetailInterface", path: "../Feature/PostDetail"),
                .project(target: "Search", path: "../Feature/Search"),
            ]
        ),
    ]
)
