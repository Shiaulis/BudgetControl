//
//  BudgetModel.swift
//  BudgetControl
//
//  Created by Andrius Shiaulis on 26.08.2023.
//

import Foundation
import Combine
import OSLog

protocol BudgetModel: AnyObject {

    func categoryListPublisher() -> AnyPublisher <[BudgetCategory.ID], Never>
    func addCategory(title: String, budget: Decimal, spent: Decimal)
    func getCategory(by id: BudgetCategory.ID) -> BudgetCategory?
    func deleteCategory(by id: BudgetCategory.ID)

}

final class PersistentBudgetModel: BudgetModel {

    @Published private var categoryIDs: [BudgetCategory.ID] = []
    private let repository: BudgetCategoryRepository
    private lazy var logger: Logger = .init(reporterType: Self.self)

    init(repository: BudgetCategoryRepository) {
        self.repository = repository
        self.logger.info("Model initialized")
    }

    // MARK: - Public API -

    func categoryListPublisher() -> AnyPublisher<[BudgetCategory.ID], Never> {
        updateCategoryIDList()
        return self.$categoryIDs.eraseToAnyPublisher()
    }

    func addCategory(title: String, budget: Decimal, spent: Decimal) {
        let category: BudgetCategory = .newCategory(title: title, budget: budget, spent: spent)

        do {
            try self.repository.save(category)
            self.logger.log("Category \"\(title)\" was created successfully")
            updateCategoryIDList()
        } catch {
            self.logger.error("Failed to create new category. Error: \(error.localizedDescription)")
            assertionFailure()
        }
    }

    func getCategory(by id: BudgetCategory.ID) -> BudgetCategory? {
        do {
            return try self.repository.category(for: id)
        } catch {
            self.logger.log("Unable to get category for ID: \(id, privacy: .public)")
            assertionFailure()
            return nil
        }
    }

    func deleteCategory(by id: BudgetCategory.ID) {
        do {
            try self.repository.deleteCategory(by: id)
            self.logger.log("Category \"\(id)\" was deleted successfully")
            updateCategoryIDList()
        } catch {
            self.logger.error("Failed to delete category with ID: \(id). Error: \(error)")
            assertionFailure()
        }
    }

    // MARK: - Private -

    private func updateCategoryIDList() {
        do {
            let categoryListIDs = try self.repository.fetchCategoryListIDs()
            self.logger.log("Fetched \(categoryListIDs.count) categories from repository")
            self.categoryIDs = categoryListIDs
        } catch {
            self.logger.error("Failed to fetch category IDs. Error: \(error.localizedDescription)")
            assertionFailure()
        }
    }

}

final class FakeBudgetModel: BudgetModel {
    func deleteCategory(by id: BudgetCategory.ID) {
        data.removeAll { $0.id == id }
    }

    func addCategory(title: String, budget: Decimal, spent: Decimal) {
        self.data.append(.generateRandom())
    }

    @Published private var data: [BudgetCategory] = [
        .generateRandom(),
        .generateRandom(),
        .generateRandom()
    ]

    func categoryListPublisher() -> AnyPublisher <[BudgetCategory.ID], Never> {
        self.$data
            .map { $0.map(\.id) }
            .eraseToAnyPublisher()
    }

    func getCategory(by id: BudgetCategory.ID) -> BudgetCategory? {
        data.first { $0.id == id }
    }

}
