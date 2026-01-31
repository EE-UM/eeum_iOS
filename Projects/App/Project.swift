import ProjectDescription

let project = Project(
    name: "App",
    organizationName: "eeum",
    packages: [],
    settings: .settings(
        base: [
            "CODE_SIGN_STYLE": "Automatic",
            "DEVELOPMENT_TEAM": "",
        ],
        defaultSettings: .recommended
    ),
    targets: [
        .target(
            name: "App",
            destinations: .iOS,
            product: .app,
            bundleId: "com.example.eeum",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                    "UIUserInterfaceStyle": "Light",
                ]
            ),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(target: "Domain", path: "../Domain"),
                .project(target: "Data", path: "../Data"),
                .project(target: "DesignSystem", path: "../DesignSystem"),
                .project(target: "Coordinator", path: "../Coordinator"),
                .project(target: "FeatureFactory", path: "../Feature/Factory"),
                .project(target: "HomeInterface", path: "../Feature/Home"),
                .project(target: "FeedInterface", path: "../Feature/Feed"),
                .project(target: "ShareInterface", path: "../Feature/Share"),
                .project(target: "Search", path: "../Feature/Search"),
                .project(target: "SettingInterface", path: "../Feature/Setting"),
                .project(target: "AuthInterface", path: "../Feature/Auth"),
                .external(name: "Moya"),
            ]
        ),
        .target(
            name: "AppTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.example.eeum.test",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "App"),
            ]
        ),
    ]
)
