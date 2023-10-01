//
//  RootSplitViewController.swift
//  BudgetControl
//
//  Created by Andrius Shiaulis on 26.08.2023.
//

import UIKit
import Combine

final class RootSplitViewController: UISplitViewController {

    // MARK: - Properties -

    private let viewModel: RootViewModel
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

    // MARK: - UIViewController cycle -

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.viewModel.didBecomeActive()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        self.viewModel.didBecomeInactive()
    }

    // MARK: - Private -

    private func setup() {
        self.delegate = self
        self.preferredDisplayMode = .oneBesideSecondary
        self.preferredSplitBehavior = .tile

        setViewController(self.viewModel.listViewController, for: .primary)
        setViewController(self.viewModel.detailsViewController, for: .secondary)
    }

    private func bindViewModel() {
        self.viewModel.$detailsViewController
            .sink { [weak self] detailsViewController in
                guard let detailsViewController else { return }
                self?.setViewController(detailsViewController, for: .secondary)
            }
            .store(in: &self.disposables)

        self.viewModel.$presentedViewController
            .sink { [weak self] presentedViewController in
                guard let self else { return }
                switch presentedViewController {
                case .some(let viewController):
                    self.present(viewController, animated: true)
                case .none:
                    self.dismiss(animated: true)
                }
            }
            .store(in: &self.disposables)

        self.viewModel.showDetailsBlock = { [weak self] in
            self?.show(.secondary)
        }
    }

}

extension RootSplitViewController: UISplitViewControllerDelegate {

    // Forces to show primary view controller on compact width
    // swiftlint:disable:next line_length
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        .primary
    }

}
