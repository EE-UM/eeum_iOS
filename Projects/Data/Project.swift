import ProjectDescription

let project = Project(
    name: "Data",
    organizationName: "eeum",
    settings: .settings(defaultSettings: .recommended(excluding: ["CODE_SIGN_IDENTITY"])),
    targets: [
        .target(
            name: "Data",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "io.tuist.eeum.data",
            deploymentTargets: .iOS("17.0"),
            sources: ["Sources/**"],
            resources: [],
            dependencies: [
                .project(target: "Domain", path: "../Domain"),
                .external(name: "Moya")
            ]
        ),
    ]
)
