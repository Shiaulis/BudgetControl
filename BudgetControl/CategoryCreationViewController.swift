//
//  CategoryCreationViewController.swift
//  BudgetControl
//
//  Created by Andrius Shiaulis on 27.08.2023.
//

import UIKit

protocol CategoryCreationViewModel {

    func createCategory(title: String, budget: Decimal)
}

final class CategoryCreationViewController: UIViewController {

    // MARK: - Properties -

    private let viewModel: CategoryCreationViewModel

    private let titleTextField: UITextField = .init()
    private let budgetTextField: UITextField = .init()

    // MARK: - Init -

    init(viewModel: CategoryCreationViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private -

    private func setup() {
        self.view.backgroundColor = .systemBackground
        self.title = NSLocalizedString("Create category", comment: "")

        self.view.addSubview(self.titleTextField)
        setupTitleTextField()

        self.view.addSubview(self.budgetTextField)
        setupBudgetTextField()
    }

    private func setupTitleTextField() {
        self.titleTextField.translatesAutoresizingMaskIntoConstraints = false
        self.titleTextField.backgroundColor = .orange

        NSLayoutConstraint.activate([
            self.titleTextField.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor),
            self.titleTextField.topAnchor.constraint(equalToSystemSpacingBelow: self.view.layoutMarginsGuide.topAnchor, multiplier: 1),
            self.titleTextField.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor)
        ])
    }

    private func setupBudgetTextField() {
        self.budgetTextField.translatesAutoresizingMaskIntoConstraints = false
        self.budgetTextField.backgroundColor = .red

        NSLayoutConstraint.activate([
            self.budgetTextField.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor),
            self.budgetTextField.topAnchor.constraint(equalToSystemSpacingBelow: self.titleTextField.bottomAnchor, multiplier: 1),
            self.budgetTextField.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor)
        ])
    }
}
