import ProjectDescription

let project = Project(
    name: "Domain",
    organizationName: "eeum",
    settings: .settings(defaultSettings: .recommended(excluding: ["CODE_SIGN_IDENTITY"])),
    targets: [
        .target(
            name: "Domain",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "io.tuist.eeum.domain",
            deploymentTargets: .iOS("17.0"),
            sources: ["Sources/**"],
            resources: [],
            dependencies: [
            ],
            settings: .settings(base: [
                "SWIFT_INSTALL_OBJC_HEADER": "YES"
            ])
        ),
    ]
)
