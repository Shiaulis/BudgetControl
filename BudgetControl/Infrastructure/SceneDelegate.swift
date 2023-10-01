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
    private lazy var rootViewModel: RootViewModel = RootViewModel(factory: self.factory)
    private lazy var rootViewController: UIViewController = RootSplitViewController(viewModel: self.rootViewModel)

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        guard ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] == nil else {
            // Code only executes when tests are running
            return
        }

        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        self.window!.rootViewController = self.rootViewController
        self.window!.makeKeyAndVisible()
    }
}
