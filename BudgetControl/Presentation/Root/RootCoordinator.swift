//
//  RootCoordinator.swift
//  BudgetControl
//
//  Created by Andrius Shiaulis on 26.08.2023.
//

import UIKit
import Combine

final class RootCoordinator {

    // MARK: - Properties -

    var viewController: UIViewController { self.splitViewController }

    private let factory: AppFactory
    private let splitViewController: RootSplitViewController = .init()

    private lazy var categoryList: CategoryListController = self.factory.makeCategoryListController()
    private lazy var categoryDetails: CategoryDetailsController = self.factory.makeCategoryDetailsController()

    // MARK: - Init -

    init(factory: AppFactory) {
        self.factory = factory

        bind(categoryList: self.categoryList)
        bind(categoryDetails: self.categoryDetails)

        setupViewControllers()
    }

    // MARK: - Private -

    private func setupViewControllers() {
        let primary = CategoryListViewController(viewModel: self.categoryList)
        self.splitViewController.setViewController(primary, for: .primary)

        let secondary = CategoryDetailsViewController(viewModel: self.categoryDetails)
        self.splitViewController.setViewController(secondary, for: .secondary)
    }

    private func makeCategoryCreationViewController() -> UIViewController {
        let controller = self.factory.makeCategoryCreationController()
        bind(categoryCreation: controller)
        let viewController = CategoryCreationViewController(viewModel: controller)
        let navigation = UINavigationController(rootViewController: viewController)
        return navigation
    }

    // MARK: - Binding controllers -

    private func bind(categoryList: CategoryListController) {
        categoryList.externalActionBlock = { [weak self] action in
            guard let self else { return }
            switch action {
            case .showCategoryCreation:
                self.showCategoryCreation()
            case .showCategoryDetails(let id):
                self.showCategoryDetails(id: id)
            }
        }
    }

    private func bind(categoryDetails: CategoryDetailsController) {
        categoryDetails.externalActionBlock = { [weak self] action in
            guard let self else { return }
            switch action {
            case .dismiss:
                self.splitViewController.show(.primary)
            }
        }
    }

    private func bind(categoryCreation: CategoryCreationController) {
        categoryCreation.externalActionBlock = { [weak self] action in
            guard let self else { return }
            switch action {
            case .dismiss:
                self.splitViewController.dismiss(animated: true)
            }
        }
    }

    // MARK: - Show -

    private func showCategoryCreation() {
        let viewController = makeCategoryCreationViewController()
        self.splitViewController.present(viewController, animated: true)
    }

    private func showCategoryDetails(id: BudgetCategory.ID) {
        self.categoryDetails.categoryID = id
        self.splitViewController.show(.secondary)
    }

}
