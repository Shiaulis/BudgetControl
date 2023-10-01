//
//  RootFactory.swift
//  BudgetControl
//
//  Created by Andrius Shiaulis on 30.08.2023.
//

import Foundation

protocol AppFactory {
    func makeCategoryListViewModel() -> CategoryListViewModel
    func makeCategoryDetailsViewModel() -> CategoryDetailsViewModel
    func makeCategoryCreationViewModel() -> CategoryCreationViewModel
}

final class RootFactory: AppFactory {
    // MARK: - Properties -

    private lazy var financeConverterService: FinanceConverterService = .init()
    private lazy var persistentContainer: PersistentContainer = .init()
    private lazy var repository = BudgetCategoryCoreDataRepository(persistentContainer: self.persistentContainer)
    private lazy var model: BudgetModel = PersistentBudgetModel(repository: self.repository)

    func makeCategoryDetailsViewModel() -> CategoryDetailsViewModel {
        CategoryDetailsViewModel(title: "title", budget: "budget", isDeleteEnabled: false)
    }

    func makeCategoryListViewModel() -> CategoryListViewModel {
        CategoryListViewModel(model: model, financeConverterService: financeConverterService)
    }

    func makeCategoryCreationViewModel() -> CategoryCreationViewModel {
        CategoryCreationViewModel(model: model, financeConverterService: financeConverterService)
    }
}
