//
//  MainViewController.swift
//  BudgetControl
//
//  Created by Andrius Shiaulis on 25.08.2023.
//

import UIKit

struct BudgetCategory: Identifiable {

    let id: String
    let title: String
    let budget: Decimal

}

protocol BudgetModel {
    func fetchCategories() -> [BudgetCategory.ID]
    func fetchCategory(by id: BudgetCategory.ID) -> BudgetCategory?
}

class MainViewController: UIViewController {

    enum Section { case main }


    // MARK: - Properties -

    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, BudgetCategory.ID>!
    private let budgetModel: BudgetModel

    fileprivate let sectionHeaderElementKind = "SectionHeader"

    // MARK: - Init -

    init(budgetModel: BudgetModel) {
        self.budgetModel = budgetModel

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
        setInitialData()
    }

    // MARK: - Private -

    private func configureHierarchy() {
        self.collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        self.collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.collectionView.backgroundColor = .systemBackground
        self.view.addSubview(self.collectionView)
    }

    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<CategoryCollectionViewCell, BudgetCategory.ID> { [weak self] cell, indexPath, categoryID in
            guard let self else { return }

            guard let category = self.budgetModel.fetchCategory(by: categoryID) else {
                assertionFailure("Didn't expect to meet an absent category")
                return
            }

            cell.configure(for: category)
        }

        self.dataSource = UICollectionViewDiffableDataSource<Section, BudgetCategory.ID>(collectionView: collectionView) {
            (collectionView, indexPath, identifier) in

            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
    }

    private func configureNavigation() {
        self.title = NSLocalizedString("Categories", comment: "")
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func createLayout() -> UICollectionViewLayout {
        let layoutConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        return UICollectionViewCompositionalLayout.list(using: layoutConfiguration)
    }

    private func setInitialData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, BudgetCategory.ID>()
        let categoryIDs = self.budgetModel.fetchCategories()
        snapshot.appendSections([.main])
        snapshot.appendItems(categoryIDs)

        self.dataSource.apply(snapshot, animatingDifferences: false)
    }

}
