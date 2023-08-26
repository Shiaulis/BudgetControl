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
    private let categoryListSubject: CurrentValueSubject<[BudgetCategory.ID], Never> = .init([])
    private let selectedCategoryViewModelSubject: CurrentValueSubject<CategoryDetailsViewModel?, Never> = .init(nil)

    // MARK: - Init -

    init(model: BudgetModel) {
        self.model = model

        let categories = model.fetchCategories()
        self.categoryListSubject.send(categories)
    }

}

extension RootController: RootViewModel {

    var selectedCategoryDetailsViewModel: any Publisher<CategoryDetailsViewModel?, Never> {
        self.selectedCategoryViewModelSubject.eraseToAnyPublisher()
    }

    func makeCategoryListViewModel() -> CategoryListViewModel {
        self
    }

}

extension RootController: CategoryListViewModel {

    var categories: any Publisher<[BudgetCategory.ID], Never> {
        self.categoryListSubject.eraseToAnyPublisher()
    }

    func getCategory(for id: BudgetCategory.ID) -> BudgetCategory? {
        self.model.fetchCategory(by: id)
    }


    func didSelectCategory(_ id: BudgetCategory.ID) {
        let category = self.model.fetchCategory(by: id)
        self.selectedCategoryViewModelSubject.send(category)
    }


}

extension BudgetCategory: CategoryDetailsViewModel {}
