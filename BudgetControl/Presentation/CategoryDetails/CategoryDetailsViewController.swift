//
//  CategoryDetailsViewController.swift
//  BudgetControl
//
//  Created by Andrius Shiaulis on 26.08.2023.
//

import UIKit
import Combine

struct CategoryDetailsConfiguration {
    let title: String
    let budget: String
    var isDeleteEnabled: Bool
}

enum CategoryDetailsState {
    case empty, details(CategoryDetailsConfiguration), error
}

protocol CategoryDetailsViewModel {

    var state: AnyPublisher<CategoryDetailsState, Never> { get }

    func delete()

}

final class CategoryDetailsViewController: UIViewController {

    // MARK: - Properties -

    private let viewModel: CategoryDetailsViewModel
    private var disposables: Set<AnyCancellable> = []

    private let temporaryStateLabel = UILabel()

    // MARK: - Init

    init(viewModel: CategoryDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        setup()
        setupNavigation()
        bindViewModel()
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

    private func setup() {
        self.view.addSubview(self.temporaryStateLabel)
        setupTemporaryStateLabel()
    }

    private func setupTemporaryStateLabel() {
        self.temporaryStateLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.temporaryStateLabel.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor),
            self.temporaryStateLabel.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor),
            self.temporaryStateLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }

    private func setupNavigation() {
        self.navigationItem.rightBarButtonItem = .systemActionItem(.trash) { [weak self] in
            self?.viewModel.delete()
        }
    }

    private func bindViewModel() {
        self.viewModel.state
            .sink { state in
                switch state {
                case .empty:
                    self.temporaryStateLabel.text = "Empty state"
                case .details(let categoryDetailsConfiguration):
                    self.temporaryStateLabel.text = "Details state with title: \(categoryDetailsConfiguration.title)"
                case .error:
                    self.temporaryStateLabel.text = "Error state"
                }
            }
            .store(in: &self.disposables)
    }

}
