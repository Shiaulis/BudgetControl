//
//  SceneDelegate.swift
//  BudgetControl
//
//  Created by Andrius Shiaulis on 25.08.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private lazy var factory: AppFactory = RootFactory()
    private var coordinators: [RootCoordinator] = []

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] == nil else {
            // Code only executes when tests are running
            return
        }

        guard let windowScene = (scene as? UIWindowScene) else { return }

        self.window = UIWindow(windowScene: windowScene)
        let coordinator = RootCoordinator(factory: self.factory)
        self.window!.rootViewController = coordinator.viewController
        self.coordinators.append(coordinator)
        self.window!.makeKeyAndVisible()
    }

}
