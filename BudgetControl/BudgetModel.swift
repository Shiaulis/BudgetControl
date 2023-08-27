//
//  BudgetModel.swift
//  BudgetControl
//
//  Created by Andrius Shiaulis on 26.08.2023.
//

import Foundation
import Combine
import OSLog

struct BudgetCategory: Identifiable {

    let id: String
    let title: String
    let budget: Decimal

}

protocol BudgetModel: AnyObject {

    func fetchCategories() -> AnyPublisher <[BudgetCategory.ID], Never>
    func addCategory(title: String, budget: Decimal)
    func getCategory(by id: BudgetCategory.ID) -> BudgetCategory?

}

final class RuntimeBudgetModel: BudgetModel {

    @Published private var categories: [BudgetCategory] = []
    private lazy var logger: Logger = .init(reporterType: Self.self)

    init() {
        self.logger.info("Model initialized")
    }

    func fetchCategories() -> AnyPublisher <[BudgetCategory.ID], Never> {
        self.$categories
            .map { $0.map(\.id) }
            .handleEvents(receiveOutput: { categories in
                self.logger.info("Fetched \(categories.count) categories")
            })
            .eraseToAnyPublisher()
    }

    func getCategory(by id: BudgetCategory.ID) -> BudgetCategory? {
        self.categories.first { $0.id == id }
    }

    func addCategory(title: String, budget: Decimal) {
        let newCategory = BudgetCategory(
            id: UUID().uuidString,
            title: title,
            budget: budget)
        self.categories.append(newCategory)
        self.logger.log("Category added. ID: \(newCategory.id)")
    }

}

final class FakeBudgetModel: BudgetModel {

    func addCategory(title: String, budget: Decimal) {
        self.data.append(.generateRandom())
    }

    @Published private var data: [BudgetCategory] = [
        .generateRandom(),
        .generateRandom(),
        .generateRandom()
    ]

    func fetchCategories() -> AnyPublisher <[BudgetCategory.ID], Never> {
        self.$data
            .map { $0.map(\.id) }
            .eraseToAnyPublisher()
    }

    func getCategory(by id: BudgetCategory.ID) -> BudgetCategory? {
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
