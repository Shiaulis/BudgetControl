//
//  RootFactory.swift
//  BudgetControl
//
//  Created by Andrius Shiaulis on 30.08.2023.
//

import Foundation

protocol AppFactory {
    func makeCategoryDetailsController() -> CategoryDetailsController
    func makeCategoryListController() -> CategoryListController
    func makeCategoryCreationController() -> CategoryCreationController
}

final class RootFactory: AppFactory {

    // MARK: - Properties -

    private lazy var financeConverterService: FinanceConverterService = .init()
    private lazy var persistentContainer: PersistentContainer = .init()
    private lazy var repository = BudgetCategoryCoreDataRepository(persistentContainer: self.persistentContainer)
    private lazy var model: BudgetModel = PersistentBudgetModel(repository: self.repository)

    func makeCategoryDetailsController() -> CategoryDetailsController {
        CategoryDetailsController(model: self.model, financeConverterService: self.financeConverterService)
    }

    func makeCategoryListController() -> CategoryListController {
        CategoryListController(model: self.model, financeConverterService: self.financeConverterService)
    }

    func makeCategoryCreationController() -> CategoryCreationController {
        CategoryCreationController(model: self.model, financeConverterService: self.financeConverterService)
    }

}
