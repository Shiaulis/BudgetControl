//
//  BudgetModel.swift
//  BudgetControl
//
//  Created by Andrius Shiaulis on 26.08.2023.
//

import Foundation

struct BudgetCategory: Identifiable {

    let id: String
    let title: String
    let budget: Decimal

}

protocol BudgetModel {
    mutating func addCategory(title: String, budget: Decimal)
    func fetchCategories() -> [BudgetCategory.ID]
    func fetchCategory(by id: BudgetCategory.ID) -> BudgetCategory?
}

struct RuntimeBudgetModel: BudgetModel {

    private var categories: [BudgetCategory] = []

    func fetchCategories() -> [BudgetCategory.ID] {
        self.categories.map { $0.id }
    }

    func fetchCategory(by id: BudgetCategory.ID) -> BudgetCategory? {
        self.categories.first { $0.id == id }
    }

    mutating func addCategory(title: String, budget: Decimal) {
        self.categories.append(.init(
            id: UUID().uuidString,
            title: title,
            budget: budget)
        )
    }

}

struct FakeBudgetModel: BudgetModel {

    mutating func addCategory(title: String, budget: Decimal) {
        self.data.append(.generateRandom())
    }

    private var data: [BudgetCategory] = [
        .generateRandom(),
        .generateRandom(),
        .generateRandom()
    ]

    func fetchCategories() -> [BudgetCategory.ID] {
        data.map { $0.id }
    }

    func fetchCategory(by id: BudgetCategory.ID) -> BudgetCategory? {
        data.first { $0.id == id }
    }

}

extension BudgetCategory {
    static func generateRandom() -> Self {
        let uuid = UUID().uuidString

        return .init(
            id: uuid,
            title: "random \(uuid)",
            budget: 1
        )
    }
}
