//
//  RootViewController.swift
//  BudgetControl
//
//  Created by Andrius Shiaulis on 26.08.2023.
//

import UIKit
import Combine

final class RootSplitViewController: UISplitViewController {

    // MARK: - Init -

    init() {
        super.init(style: .doubleColumn)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private -

    private func setup() {
        self.delegate = self
        self.preferredDisplayMode = .oneBesideSecondary
        self.preferredSplitBehavior = .tile
    }

}

extension RootSplitViewController: UISplitViewControllerDelegate {

    // Forces to show primary view controller on compact width
    // swiftlint:disable:next line_length
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        .primary
    }

}
