import ProjectDescription

let project = Project(
    name: "PostDetail",
    organizationName: "eeum",
    settings: .settings(defaultSettings: .recommended(excluding: ["CODE_SIGN_IDENTITY"])),
    targets: [
        .target(
            name: "PostDetailInterface",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "io.tuist.eeum.postdetail.interface",
            deploymentTargets: .iOS("17.0"),
            sources: ["Sources/Interface/**"],
            resources: [],
            dependencies: [
                .project(target: "Domain", path: "../../Domain")
            ]
        ),
        .target(
            name: "PostDetail",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "io.tuist.eeum.postdetail",
            deploymentTargets: .iOS("17.0"),
            sources: ["Sources/Implementation/**"],
            resources: [],
            dependencies: [
                .target(name: "PostDetailInterface"),
                .project(target: "Domain", path: "../../Domain"),
                .project(target: "DesignSystem", path: "../../DesignSystem"),
            ]
        ),
    ]
)
