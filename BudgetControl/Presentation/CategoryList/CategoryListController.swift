//
//  CategoryListController.swift
//  BudgetControl
//
//  Created by Andrius Shiaulis on 01.09.2023.
//

import Foundation
import Combine

final class CategoryListController: CategoryListViewModel {

    enum ExternalAction {
        case showCategoryDetails(BudgetCategory.ID)
        case showCategoryCreation
    }

    // MARK: - Properties -

    var externalActionBlock: ((ExternalAction) -> Void)!

    private let model: BudgetModel
    private let financeConverterService: FinanceConverterService
    @Published private var categories: [BudgetCategory.ID] = []
    private var disposables: Set<AnyCancellable> = []

    // MARK: - Init -

    init(model: BudgetModel, financeConverterService: FinanceConverterService) {
        self.model = model
        self.financeConverterService = financeConverterService

        bindModel()
    }

    // MARK: - CategoryListViewModel -

    func makeCategoriesPublisher() -> AnyPublisher<[BudgetCategory.ID], Never> {
        self.$categories.eraseToAnyPublisher()
    }

    func getConfiguration(for id: BudgetCategory.ID) -> CategoryListItemConfiguration? {
        guard let category = getCategory(for: id) else {
            return nil
        }

        return mapConfiguration(from: category)
    }

    func didSelectCategory(_ id: BudgetCategory.ID) {
        self.externalActionBlock(.showCategoryDetails(id))
    }

    func createNewCategory() {
        self.externalActionBlock(.showCategoryCreation)
    }

    // MARK: - Private -

    private func bindModel() {
        self.model.categoryListPublisher()
            .sink { [weak self] categories in
                self?.categories = categories
            }
            .store(in: &self.disposables)
    }

    private func getCategory(for id: BudgetCategory.ID) -> BudgetCategory? {
        self.model.getCategory(by: id)
    }

    private func mapConfiguration(from category: BudgetCategory) -> CategoryListItemConfiguration {
        .init(
            title: category.title,
            budgetTotalValue: self.financeConverterService.makeCurrencyString(from: category.budget) ?? "",
            budgetSpentValue: self.financeConverterService.makeCurrencyString(from: category.spent) ?? "",
            id: category.id
        )
    }

}
