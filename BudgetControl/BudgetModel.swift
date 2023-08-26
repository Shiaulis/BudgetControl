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
    func fetchCategories() -> [BudgetCategory.ID]
    func fetchCategory(by id: BudgetCategory.ID) -> BudgetCategory?
}

struct FakeBudgetModel: BudgetModel {

    private let data: [BudgetCategory] = [
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
