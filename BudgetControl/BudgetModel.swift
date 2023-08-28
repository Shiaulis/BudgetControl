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
    func addCategory(title: String, budget: Decimal)
    func getCategory(by id: BudgetCategory.ID) -> BudgetCategory?

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

    func addCategory(title: String, budget: Decimal) {
        let category: BudgetCategory = .newCategory(title: title, budget: budget)

        do {
            try self.repository.save(category)
            self.logger.log("Category with title: \"\(title)\" was saved successfully")
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

    func addCategory(title: String, budget: Decimal) {
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
