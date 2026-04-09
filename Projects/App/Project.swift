import ProjectDescription

let project = Project(
    name: "App",
    organizationName: "eeum",
    packages: [],
    settings: .settings(
        base: [
            "DEVELOPMENT_TEAM": "AU24ZRJ649",
            "CODE_SIGN_STYLE": "Automatic",
        ],
        defaultSettings: .recommended(excluding: ["CODE_SIGN_IDENTITY"])
    ),
    targets: [
        .target(
            name: "App",
            destinations: .iOS,
            product: .app,
            bundleId: "com.eeum.app",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(
                with: [
                    "CFBundleName": "이음",
                    "CFBundleDisplayName": "이음",
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                    "UIUserInterfaceStyle": "Light",
                    "CFBundleShortVersionString": "1.0.0",
                    "CFBundleVersion": "2",
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
            ],
            settings: .settings(
                base: [
                    "PRODUCT_NAME": "eeum",
                ],
                configurations: [
                    .debug(name: "Debug", settings: [:]),
                    .release(name: "Release", settings: [:]),
                ],
                defaultSettings: .recommended(excluding: ["CODE_SIGN_IDENTITY"])
            )
        ),
        .target(
            name: "AppTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.app.eeum.test",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "App"),
            ]
        ),
    ],
    schemes: [
        .scheme(
            name: "이음",
            shared: true,
            buildAction: .buildAction(targets: ["App"]),
            runAction: .runAction(configuration: .debug),
            archiveAction: .archiveAction(configuration: .release),
            profileAction: .profileAction(configuration: .release),
            analyzeAction: .analyzeAction(configuration: .debug)
        )
    ]
)
