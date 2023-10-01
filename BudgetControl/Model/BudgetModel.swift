//
//  BudgetModel.swift
//  BudgetControl
//
//  Created by Andrius Shiaulis on 26.08.2023.
//

import Combine
import Foundation
import OSLog

protocol BudgetModel: AnyObject {
    func categoryListPublisher() -> AnyPublisher<[BudgetCategory.ID], Never>
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
        logger.info("Model initialized")
    }

    // MARK: - Public API -

    func categoryListPublisher() -> AnyPublisher<[BudgetCategory.ID], Never> {
        updateCategoryIDList()
        return $categoryIDs.eraseToAnyPublisher()
    }

    func addCategory(title: String, budget: Decimal, spent: Decimal) {
        let category: BudgetCategory = .newCategory(title: title, budget: budget, spent: spent)

        do {
            try repository.save(category)
            logger.log("Category \"\(title)\" was created successfully")
            updateCategoryIDList()
        } catch {
            logger.error("Failed to create new category. Error: \(error.localizedDescription)")
            assertionFailure()
        }
    }

    func getCategory(by id: BudgetCategory.ID) -> BudgetCategory? {
        do {
            return try repository.category(for: id)
        } catch {
            logger.log("Unable to get category for ID: \(id, privacy: .public)")
            assertionFailure()
            return nil
        }
    }

    func deleteCategory(by id: BudgetCategory.ID) {
        do {
            try repository.deleteCategory(by: id)
            logger.log("Category \"\(id)\" was deleted successfully")
            updateCategoryIDList()
        } catch {
            logger.error("Failed to delete category with ID: \(id). Error: \(error)")
            assertionFailure()
        }
    }

    // MARK: - Private -

    private func updateCategoryIDList() {
        do {
            let categoryListIDs = try repository.fetchCategoryListIDs()
            logger.log("Fetched \(categoryListIDs.count) categories from repository")
            categoryIDs = categoryListIDs
        } catch {
            logger.error("Failed to fetch category IDs. Error: \(error.localizedDescription)")
            assertionFailure()
        }
    }
}

final class FakeBudgetModel: BudgetModel {
    func deleteCategory(by id: BudgetCategory.ID) {
        data.removeAll { $0.id == id }
    }

    func addCategory(title _: String, budget _: Decimal, spent _: Decimal) {
        data.append(.generateRandom())
    }

    @Published private var data: [BudgetCategory] = [
        .generateRandom(),
        .generateRandom(),
        .generateRandom(),
    ]

    func categoryListPublisher() -> AnyPublisher<[BudgetCategory.ID], Never> {
        $data
            .map { $0.map(\.id) }
            .eraseToAnyPublisher()
    }

    func getCategory(by id: BudgetCategory.ID) -> BudgetCategory? {
        data.first { $0.id == id }
    }
}
