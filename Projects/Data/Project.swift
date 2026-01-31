import ProjectDescription

let project = Project(
    name: "Data",
    organizationName: "eeum",
    settings: .settings(defaultSettings: .recommended),
    targets: [
        .target(
            name: "Data",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "io.tuist.eeum.data",
            deploymentTargets: .iOS("18.0"),
            sources: ["Sources/**"],
            resources: [],
            dependencies: [
                .project(target: "Domain", path: "../Domain"),
                .external(name: "Moya")
            ]
        ),
    ]
)
