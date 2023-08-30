//
//  SceneDelegate.swift
//  BudgetControl
//
//  Created by Andrius Shiaulis on 25.08.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private let factory: AppFactory = RootFactory()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] == nil else {
            // Code only executes when tests are running
            return
        }

        guard let windowScene = (scene as? UIWindowScene) else { return }

        self.window = UIWindow(windowScene: windowScene)
        let rootController = self.factory.makeRootController()
        let rootViewController = RootViewController(viewModel: rootController)
        self.window!.rootViewController = rootViewController
        self.window!.makeKeyAndVisible()
    }

}
