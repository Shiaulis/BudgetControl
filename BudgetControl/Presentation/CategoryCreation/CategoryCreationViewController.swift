//
//  CategoryCreationViewController.swift
//  BudgetControl
//
//  Created by Andrius Shiaulis on 27.08.2023.
//

import UIKit
import CurrencyFormatter
import CurrencyUITextFieldDelegate

struct CategoryCreationConfiguration {

    let titlePlaceholder = NSLocalizedString("Category name", comment: "")
    let budgetPlaceholder = NSLocalizedString("Budget amount", comment: "")
    let spentForNowPlaceholder = NSLocalizedString("Spent for now", comment: "")

}

protocol CategoryCreationViewModel {

    var configuration: CategoryCreationConfiguration { get }
    func saveTapped(title: String?, budget: String?)
    func dismiss()
}

final class CategoryCreationViewController: UIViewController {

    // MARK: - Properties -

    private let viewModel: CategoryCreationViewModel

    private let titleTextField: UITextField = .init()
    private let budgetTextField: UITextField = .init()
    private let spentForNowTextField: UITextField = .init()

    // MARK: - Init -

    init(viewModel: CategoryCreationViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)

        setup()
        setupNavigation()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private -

    private func setup() {
        self.view.backgroundColor = .systemGroupedBackground

        self.view.addSubview(self.titleTextField)
        setupTitleTextField()

        self.view.addSubview(self.budgetTextField)
        setupBudgetTextField()

        self.view.addSubview(self.spentForNowTextField)
        setupSpentForNowTextField()
    }

    private func setupTitleTextField() {
        self.titleTextField.translatesAutoresizingMaskIntoConstraints = false
        self.titleTextField.borderStyle = .roundedRect
        self.titleTextField.placeholder = self.viewModel.configuration.titlePlaceholder
        self.titleTextField.becomeFirstResponder()

        NSLayoutConstraint.activate([
            self.titleTextField.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor),
            self.titleTextField.topAnchor.constraint(equalToSystemSpacingBelow: self.view.layoutMarginsGuide.topAnchor, multiplier: 1),
            self.titleTextField.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor)
        ])
    }

    private func setupBudgetTextField() {
        self.budgetTextField.translatesAutoresizingMaskIntoConstraints = false
        self.budgetTextField.borderStyle = .roundedRect
        self.budgetTextField.placeholder = self.viewModel.configuration.budgetPlaceholder
        self.budgetTextField.keyboardType = .decimalPad

        NSLayoutConstraint.activate([
            self.budgetTextField.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor),
            self.budgetTextField.topAnchor.constraint(equalToSystemSpacingBelow: self.titleTextField.bottomAnchor, multiplier: 1),
            self.budgetTextField.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor)
        ])
    }

    private func setupSpentForNowTextField() {
        self.spentForNowTextField.translatesAutoresizingMaskIntoConstraints = false
        self.spentForNowTextField.borderStyle = .roundedRect
        self.spentForNowTextField.placeholder = self.viewModel.configuration.spentForNowPlaceholder
        self.budgetTextField.keyboardType = .decimalPad

        NSLayoutConstraint.activate([
            self.spentForNowTextField.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor),
            self.spentForNowTextField.topAnchor.constraint(equalToSystemSpacingBelow: self.budgetTextField.bottomAnchor, multiplier: 1),
            self.spentForNowTextField.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor)
        ])
    }

    private func setupNavigation() {
        self.title = NSLocalizedString("New category", comment: "")
        self.navigationItem.rightBarButtonItem = .systemActionItem(.save) { [weak self] in
            guard let self else { return }
            self.viewModel.saveTapped(title: self.titleTextField.text, budget: self.budgetTextField.text)
        }

        self.navigationItem.leftBarButtonItem = .systemActionItem(.cancel) { [weak self] in
            guard let self else { return }
            self.viewModel.dismiss()
        }
    }
}
