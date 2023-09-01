//
//  CategoryCollectionViewCell.swift
//  BudgetControl
//
//  Created by Andrius Shiaulis on 25.08.2023.
//

import UIKit

final class CategoryCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties -

    private let titleLabel = UILabel()
    private let budgetTotalView = BudgetView()
    private let budgetSpentView = BudgetView()

    // MARK: - Init -

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public interface -

    func configure(for configuration: CategoryListItemConfiguration) {
        self.titleLabel.text = configuration.title
        self.budgetTotalView.titleLabel.text = configuration.budgetTotalTitle
        self.budgetTotalView.valueLabel.text = configuration.budgetTotalValue
        self.budgetSpentView.titleLabel.text = configuration.budgetSpentTitle
        self.budgetSpentView.valueLabel.text = configuration.budgetSpentValue
    }

    // MARK: - Private -

    private func setup() {
        addSubview(self.titleLabel)
        setupTitleLabel()

        addSubview(self.budgetTotalView)
        setupBudgetTotalView()

        addSubview(self.budgetSpentView)
        setupBudgetSpentView()
    }

    private func setupTitleLabel() {
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.font = .preferredFont(forTextStyle: .title2)

        NSLayoutConstraint.activate([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            self.titleLabel.topAnchor.constraint(equalToSystemSpacingBelow: self.topAnchor, multiplier: 1),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor)

        ])
    }

    private func setupBudgetTotalView() {
        self.budgetTotalView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.budgetTotalView.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            self.budgetTotalView.topAnchor.constraint(equalToSystemSpacingBelow: self.titleLabel.bottomAnchor, multiplier: 1),
            self.budgetTotalView.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor)
        ])
    }

    private func setupBudgetSpentView() {
        self.budgetSpentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.budgetSpentView.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            self.budgetSpentView.topAnchor.constraint(equalToSystemSpacingBelow: self.budgetTotalView.bottomAnchor, multiplier: 1),
            self.budgetSpentView.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            self.bottomAnchor.constraint(equalToSystemSpacingBelow: self.budgetSpentView.bottomAnchor, multiplier: 1)
        ])
    }
}

private class BudgetView: UIStackView {

    // MARK: - Properties -
    let titleLabel = UILabel()
    let valueLabel = UILabel()

    // MARK: - Init -

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private -

    private func setup() {
        self.axis = .horizontal
        self.distribution = .fill
        self.addArrangedSubview(self.titleLabel)
        setupTitleLabel()
        self.addArrangedSubview(self.valueLabel)
        setupValueLabel()
    }

    private func setupTitleLabel() {
        self.titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }

    private func setupValueLabel() {
        self.valueLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        self.valueLabel.textAlignment = .right
    }

}
