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
    @Published private var routeCommand: RootViewModelRouteCommand?
    @Published private var categoryList: [BudgetCategory.ID] = []

    private var disposables: Set<AnyCancellable> = []

    // MARK: - Init -

    init(model: BudgetModel) {
        self.model = model

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

}

extension RootController: RootViewModel {

    var show: AnyPublisher<RootViewModelRouteCommand?, Never> {
        self.$routeCommand.eraseToAnyPublisher()
    }

    func makeCategoryListViewModel() -> CategoryListViewModel {
        self
    }

}

extension RootController: CategoryListViewModel {

    var categories: AnyPublisher<[BudgetCategory.ID], Never> {
        self.$categoryList.eraseToAnyPublisher()
    }

    func getCategory(for id: BudgetCategory.ID) -> BudgetCategory? {
        self.model.getCategory(by: id)
    }

    func didSelectCategory(_ id: BudgetCategory.ID) {
        let category = self.model.getCategory(by: id)
        self.routeCommand = .categoryDetails(category)
    }

    func createNewCategory() {
        self.routeCommand = .categoryCreation(self)
    }

}

extension RootController: CategoryCreationViewModel {

    func createCategory(title: String?, budget: String?) {
        guard let title else {
            assertionFailure("We need to add input validation in future")
            return
        }

        guard let budgetDecimalValue = Decimal(string: budget ?? "0") else {
            assertionFailure("We need to add input validation in future")
            return
        }

        requestAddNewCategory(title: title, budget: budgetDecimalValue)
        self.routeCommand = .dismiss
    }

}

extension BudgetCategory: CategoryDetailsViewModel {}
