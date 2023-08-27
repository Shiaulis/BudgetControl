//
//  RootViewController.swift
//  BudgetControl
//
//  Created by Andrius Shiaulis on 26.08.2023.
//

import UIKit
import Combine

final class RootViewController: UISplitViewController {

    // MARK: - Properties -

    private let viewModel: RootViewModel
    private var categoryDetailsViewController: CategoryDetailsViewController!
    private var disposables: Set<AnyCancellable> = []

    // MARK: - Init -

    init(viewModel: RootViewModel) {
        self.viewModel = viewModel
        super.init(style: .doubleColumn)
        setup()
        bindViewModel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private -

    private func setup() {
        setupPrimaryViewController()
        setupSecondaryViewController()

        self.delegate = self
        self.preferredDisplayMode = .oneBesideSecondary
        self.preferredSplitBehavior = .tile
    }

    private func setupPrimaryViewController() {
        let listViewModel = viewModel.makeCategoryListViewModel()
        let categoryList = CategoryListViewController(viewModel: listViewModel)
        setViewController(categoryList, for: .primary)
    }

    private func setupSecondaryViewController() {
        self.categoryDetailsViewController = CategoryDetailsViewController()
        setViewController(self.categoryDetailsViewController, for: .secondary)
    }

    private func bindViewModel() {
        self.viewModel.show
            .sink { [weak self] command in
                guard let self else { return }
                switch command {
                case .categoryDetails(let viewModel):
                    self.showCategoryDetails(using: viewModel)
                case .categoryCreation(let viewModel):
                    self.showCategoryCreation(using: viewModel)
                case .none:
                    break
                }
            }
            .store(in: &self.disposables)
    }

    private func showCategoryDetails(using viewModel: CategoryDetailsViewModel?) {
        self.categoryDetailsViewController.viewModel = viewModel
        self.show(.secondary)
    }

    private func showCategoryCreation(using viewModel: CategoryCreationViewModel) {
        let categoryCreationViewController = CategoryCreationViewController(viewModel: viewModel)
        let navigation = UINavigationController(rootViewController: categoryCreationViewController)
        present(navigation, animated: true)
    }
}

extension RootViewController: UISplitViewControllerDelegate {

    // Forces to show primary view controller on compact width
    // swiftlint:disable:next line_length
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        .primary
    }

}
