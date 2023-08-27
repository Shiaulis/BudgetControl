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

    // MARK: - Init -

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public interface -

    func configure(for category: BudgetCategory) {
        self.titleLabel.text = category.title
    }

    // MARK: - Private -

    private func setup() {
        addSubview(self.titleLabel)
        setupTitleLabel()
    }

    private func setupTitleLabel() {
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            self.titleLabel.topAnchor.constraint(equalToSystemSpacingBelow: self.topAnchor, multiplier: 1),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            self.bottomAnchor.constraint(equalToSystemSpacingBelow: self.titleLabel.bottomAnchor, multiplier: 1)
        ])
    }

}
