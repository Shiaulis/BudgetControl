//
//  CategoryCreationController.swift
//  BudgetControl
//
//  Created by Andrius Shiaulis on 01.09.2023.
//

import Foundation
import OSLog

final class CategoryCreationController: CategoryCreationViewModel {

    enum ExternalAction {
        case dismiss
    }

    var externalActionBlock: ((ExternalAction) -> Void)!
    private let model: BudgetModel
    private let financeConverterService: FinanceConverterService
    private lazy var logger: Logger = .init(reporterType: Self.self)


    init(model: BudgetModel, financeConverterService: FinanceConverterService) {
        self.model = model
        self.financeConverterService = financeConverterService
    }

    var configuration: CategoryCreationConfiguration { .init() }

    func saveTapped(title: String?, budgetTotal: String?, budgetSpent: String?) {
        guard let title else {
            self.logger.error("Nil title value during category creation is not expected")
            assertionFailure()
            return
        }

        guard let budgetDecimalValue = self.financeConverterService.makeDecimal(from: budgetTotal ?? "0") else {
            self.logger.error("Nil budget total value during category creation is not expected")
            assertionFailure()
            return
        }

        guard let spentDecimalValue = self.financeConverterService.makeDecimal(from: budgetSpent ?? "0") else {
            self.logger.error("Nil budget spent value during category creation is not expected")
            assertionFailure()
            return
        }

        requestAddNewCategory(title: title, budget: budgetDecimalValue, spent: spentDecimalValue)
        dismiss()
    }

    func dismiss() {
        self.externalActionBlock(.dismiss)
    }

    private func requestAddNewCategory(title: String, budget: Decimal, spent: Decimal) {
        Task {
            self.model.addCategory(title: title, budget: budget, spent: spent)
        }
    }

}
