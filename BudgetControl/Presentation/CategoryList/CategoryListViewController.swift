//
//  CategoryListViewController.swift
//  BudgetControl
//
//  Created by Andrius Shiaulis on 25.08.2023.
//

import UIKit
import Combine

struct CategoryListItemConfiguration {
    let title: String
    let budgetTitle: String = NSLocalizedString("Budget", comment: "")
    let budgetValue: String
    let id: BudgetCategory.ID
}

protocol CategoryListViewModel {

    var categories: AnyPublisher<[BudgetCategory.ID], Never> { get }

    func didSelectCategory(_ id: BudgetCategory.ID)
    func getConfiguration(for id: BudgetCategory.ID) -> CategoryListItemConfiguration?
    func createNewCategory()

}

final class CategoryListViewController: UIViewController {

    enum Section { case main }

    // MARK: - Properties -

    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, BudgetCategory.ID>!
    private let viewModel: CategoryListViewModel
    private var disposables: Set<AnyCancellable> = []

    // MARK: - Init -

    init(viewModel: CategoryListViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigation()
        configureHierarchy()
        configureDataSource()
        bindViewModel()
    }

}

extension CategoryListViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let itemIdentifier = self.dataSource.itemIdentifier(for: indexPath) else {
            assertionFailure("Absence of identifier should be investigated")
            return
        }

        self.viewModel.didSelectCategory(itemIdentifier)
    }
}

// MARK: - Private -

extension CategoryListViewController {

    private func bindViewModel() {
        self.viewModel.categories
            .receive(on: RunLoop.main)
            .sink { categories in
                self.applySnapshot(using: categories)
            }
            .store(in: &self.disposables)
    }

    private func configureHierarchy() {
        self.collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        self.collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.collectionView.backgroundColor = .systemBackground
        self.collectionView.delegate = self
        self.view.addSubview(self.collectionView)
    }

    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<CategoryCollectionViewCell, BudgetCategory.ID> { [weak self] cell, _, categoryID in
            guard let self else { return }

            guard let configuration = self.viewModel.getConfiguration(for: categoryID) else {
                assertionFailure("Didn't expect to meet an absent category")
                return
            }

            cell.configure(for: configuration)
        }

        self.dataSource = UICollectionViewDiffableDataSource<Section, BudgetCategory.ID>(collectionView: collectionView) { (collectionView, indexPath, identifier) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
    }

    private func configureNavigation() {
        self.title = NSLocalizedString("Categories", comment: "")
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.rightBarButtonItem = .systemActionItem(.add) { [weak self] in
            self?.viewModel.createNewCategory()
        }
    }

    private func createLayout() -> UICollectionViewLayout {
        let layoutConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        return UICollectionViewCompositionalLayout.list(using: layoutConfiguration)
    }

    private func applySnapshot(using items: [BudgetCategory.ID]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, BudgetCategory.ID>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)

        self.dataSource.apply(snapshot, animatingDifferences: false)
    }

}
