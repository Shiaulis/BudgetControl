//
//  SceneDelegate.swift
//  BudgetControl
//
//  Created by Andrius Shiaulis on 25.08.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] == nil else {
            // Code only executes when tests are running
            return
        }

        guard let windowScene = (scene as? UIWindowScene) else { return }

        self.window = UIWindow(windowScene: windowScene)
        let persistentContainer = PersistentContainer()
        let repository = BudgetCategoryCoreDataRepository(persistentContainer: persistentContainer)
        let model = PersistentBudgetModel(repository: repository)
        let rootController = RootController(model: model)
        let rootViewController = RootViewController(viewModel: rootController)
        self.window!.rootViewController = rootViewController
        self.window!.makeKeyAndVisible()
    }

}
