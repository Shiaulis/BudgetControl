//
//  RootController.swift
//  BudgetControl
//
//  Created by Andrius Shiaulis on 26.08.2023.
//

import Foundation
import Combine

final class RootController {

    // MARK: - Properties -

    private let model: BudgetModel
    private let financeConverterService: FinanceConverterService
    private let factory: AppFactory

    @Published private var routeCommand: RootViewModelRouteCommand?
    @Published private var categoryList: [BudgetCategory.ID] = []

    private lazy var categoryDetails: CategoryDetailsController = self.factory.makeCategoryDetailsController()

    private var disposables: Set<AnyCancellable> = []

    // MARK: - Init -

    init(model: BudgetModel, financeConverterService: FinanceConverterService, factory: AppFactory) {
        self.model = model
        self.financeConverterService = financeConverterService
        self.factory = factory

        self.categoryDetails.completion = {
            self.routeCommand = .categoryList
        }
        bindModel()
    }

    // MARK: - Private -

    private func bindModel() {
        self.model.categoryListPublisher()
            .sink { categoryList in
                self.categoryList = categoryList
            }
            .store(in: &self.disposables)
    }

    private func requestAddNewCategory(title: String, budget: Decimal) {
        Task {
            self.model.addCategory(title: title, budget: budget)
        }
    }

    private func getCategory(for id: BudgetCategory.ID) -> BudgetCategory? {
        self.model.getCategory(by: id)
    }

    private func mapConfiguration(from category: BudgetCategory) -> CategoryListItemConfiguration {
        .init(
            title: category.title,
            budgetValue: self.financeConverterService.makeCurrencyString(from: category.budget) ?? "",
            id: category.id
        )
    }
}

extension RootController: RootViewModel {

    var show: AnyPublisher<RootViewModelRouteCommand?, Never> {
        self.$routeCommand.eraseToAnyPublisher()
    }

    func makeCategoryListViewModel() -> CategoryListViewModel {
        self
    }

    func makeCategoryDetailsViewModel() -> CategoryDetailsViewModel {
        self.categoryDetails
    }

}

extension RootController: CategoryListViewModel {

    var categories: AnyPublisher<[BudgetCategory.ID], Never> {
        self.$categoryList.eraseToAnyPublisher()
    }

    func getConfiguration(for id: BudgetCategory.ID) -> CategoryListItemConfiguration? {
        guard let category = getCategory(for: id) else {
            return nil
        }

        return mapConfiguration(from: category)
    }

    func didSelectCategory(_ id: BudgetCategory.ID) {
        self.categoryDetails.categoryID = id
        self.routeCommand = .categoryDetails
    }

    func createNewCategory() {
        self.routeCommand = .categoryCreation(self)
    }

}

extension RootController: CategoryCreationViewModel {

    var configuration: CategoryCreationConfiguration { .init() }

    func saveTapped(title: String?, budget: String?) {
        guard let title else {
            assertionFailure("We need to add input validation in future")
            return
        }

        guard let budgetDecimalValue = self.financeConverterService.makeDecimal(from: budget ?? "0") else {
            assertionFailure("We need to add input validation in future")
            return
        }

        requestAddNewCategory(title: title, budget: budgetDecimalValue)
        self.routeCommand = .dismiss
    }

    func dismiss() {
        self.routeCommand = .dismiss
    }

}
