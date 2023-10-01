//
//  RootViewModel.swift
//  BudgetControl
//
//  Created by Andrius Shiaulis on 01.10.2023.
//

import UIKit
import Combine

/// Provides high level configuration for root split
final class RootViewModel {

    enum SplitSide {
        case list, details
    }

    // MARK: - Properties -

    @Published var listViewController: UIViewController!
    @Published var detailsViewController: UIViewController?
    @Published var presentedViewController: UIViewController?

    var showDetailsBlock: (() -> Void)!

    private let factory: AppFactory

    // MARK: - Init -

    init(factory: AppFactory) {
        self.factory = factory

        setup()
    }

    func didBecomeActive() {}

    func didBecomeInactive() {}

    // MARK: - Private -

    private func setup() {
        self.listViewController = makeListViewController()
        self.detailsViewController = UINavigationController(rootViewController: EmptyDetailsViewController())
    }

    private func makeListViewController() -> UIViewController {
        let viewModel = self.factory.makeCategoryListViewModel()
        viewModel.externalActionBlock = { [weak self] externalAction in
            guard let self else { return }
            switch externalAction {
            case .showCategoryDetails(let categoryID):
                self.setupCategoryDetailsFlow(using: categoryID)
            case .showCategoryCreation:
                setupCategoryCreationFlow()
            }
        }
        return CategoryListViewController(viewModel: viewModel)
    }

    private func setupCategoryDetailsFlow(using categoryID: BudgetCategory.ID) {
        let viewModel = self.factory.makeCategoryDetailsViewModel()
        self.detailsViewController = UINavigationController(rootViewController: CategoryDetailsViewController(viewModel: viewModel))
        self.showDetailsBlock()
    }

    private func setupCategoryCreationFlow() {
        let viewModel = self.factory.makeCategoryCreationViewModel()
        let viewController = CategoryCreationViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)

        viewModel.externalActionBlock = { [weak self] externalAction in
            switch externalAction {
            case .dismiss:
                self?.presentedViewController = nil
            }
        }

        self.presentedViewController = navigationController
    }
}
