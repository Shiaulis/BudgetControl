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
    @Published private var categoryList: [BudgetCategory.ID]

    // MARK: - Init -

    init(model: BudgetModel) {
        self.model = model

        self.categoryList = model.fetchCategories()
    }

}

extension RootController: RootViewModel {
    var show: any Publisher<RootViewModelRouteCommand?, Never> {
        self.$routeCommand.eraseToAnyPublisher()
    }

    func makeCategoryListViewModel() -> CategoryListViewModel {
        self
    }

}

extension RootController: CategoryListViewModel {

    var categories: any Publisher<[BudgetCategory.ID], Never> {
        self.$categoryList.eraseToAnyPublisher()
    }

    func getCategory(for id: BudgetCategory.ID) -> BudgetCategory? {
        self.model.fetchCategory(by: id)
    }

    func didSelectCategory(_ id: BudgetCategory.ID) {
        let category = self.model.fetchCategory(by: id)
        self.routeCommand = .categoryDetails(category)
    }

    func createNewCategory() {
        self.routeCommand = .categoryCreation(self)
    }

}

extension RootController: CategoryCreationViewModel {

    func createCategory(title: String, budget: Decimal) {
        print("")
    }

}

extension BudgetCategory: CategoryDetailsViewModel {}
