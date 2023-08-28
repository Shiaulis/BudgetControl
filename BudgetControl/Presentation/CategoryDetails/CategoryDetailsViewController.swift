//
//  CategoryDetailsViewController.swift
//  BudgetControl
//
//  Created by Andrius Shiaulis on 26.08.2023.
//

import UIKit

final class CategoryDetailsViewController: UIViewController {

    // MARK: - Properties -

    var viewModel: CategoryDetailsViewModel? {
        didSet {
            self.title = viewModel?.title
        }
    }

    // MARK: - Init

    init() {
        super.init(nibName: nil, bundle: nil)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View controller life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemBackground
    }

    // MARK: - Private -

    private func setup() {}

}
