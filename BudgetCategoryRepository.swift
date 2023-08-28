//
//  BudgetCategoryRepository.swift
//  BudgetControl
//
//  Created by Andrius Shiaulis on 28.08.2023.
//

import Foundation
import CoreData

struct BudgetCategory: Identifiable {

    let id: String
    let title: String
    let budget: Decimal

    fileprivate init(id: String, title: String, budget: Decimal) {
        self.id = id
        self.title = title
        self.budget = budget
    }

    static func newCategory(title: String, budget: Decimal) -> BudgetCategory {
        .init(id: newCategoryID, title: title, budget: budget)
    }

    fileprivate static let newCategoryID: BudgetCategory.ID = "newCategory"

    static func generateRandom() -> Self {
        let uuid = UUID().uuidString

        return .init(
            id: uuid,
            title: "random \(uuid)",
            budget: 1
        )
    }

}

protocol BudgetCategoryRepository {

    func fetchCategoryListIDs() throws -> [BudgetCategory.ID]
    func category(for id: BudgetCategory.ID) throws -> BudgetCategory
    func save(_ category: BudgetCategory) throws

}

final class BudgetCategoryCoreDataRepository: BudgetCategoryRepository {

    // MARK: - Properties

    private let persistentContainer: PersistentContainer
    private var mainContext: NSManagedObjectContext { self.persistentContainer.viewContext }

    // MARK: - Init -

    init(persistentContainer: PersistentContainer) {
        self.persistentContainer = persistentContainer
    }

    // MARK: - BudgetCategoryRepository -

    func fetchCategoryListIDs() throws -> [BudgetCategory.ID] {
        try self.mainContext.performAndWait {
            let objectIDs = try BCBudgetCategory.FetchRequests.allCategoryListIDs().execute()
            return objectIDs.map { convertToString($0) }
        }
    }

    func category(for id: BudgetCategory.ID) throws -> BudgetCategory {
        try self.mainContext.performAndWait {
            let expectedObject = try expectedObject(for: id)
            let category = mapCategory(from: expectedObject)
            return category
        }
    }

    func save(_ category: BudgetCategory) throws {
        try self.mainContext.performAndWait {
            if let existingObject = try existingObject(for: category) {
                update(existingObject, from: category)
            } else {
                try createBCCategory(from: category)
            }

            if self.mainContext.hasChanges {
                try self.mainContext.save()
            }
        }
    }

    // MARK: - Private -

    private func mapCategory(from bcCategory: BCBudgetCategory) -> BudgetCategory {
        .init(
            id: convertToString(bcCategory.objectID),
            title: bcCategory.title,
            budget: bcCategory.budget as Decimal
        )
    }

    private func convertToString(_ objectID: NSManagedObjectID) -> String {
        objectID.uriRepresentation().absoluteString
    }

    private func convertToManagedObjectID(_ string: String) throws -> NSManagedObjectID {
        guard let url = URL(string: string) else {
            throw Error.unableToMakeObjectURLFromString
        }

        let coordinator = self.persistentContainer.persistentStoreCoordinator
        guard let objectID = coordinator.managedObjectID(forURIRepresentation: url) else {
            throw Error.unableToGenerateObjectIDForURL
        }

        return objectID
    }

    private func existingObject(for category: BudgetCategory) throws -> BCBudgetCategory? {
        guard category.id != BudgetCategory.newCategoryID else {
            return nil
        }

        let objectID = try convertToManagedObjectID(category.id)
        return try self.mainContext.existingObject(with: objectID) as? BCBudgetCategory
    }

    private func update(_ bcCategory: BCBudgetCategory, from category: BudgetCategory) {
        bcCategory.title = category.title
        bcCategory.budget = category.budget as NSDecimalNumber
    }

    private func createBCCategory(from category: BudgetCategory) throws {
        guard let newObject = BCBudgetCategory.create(in: self.mainContext) else {
            throw Error.wrongObjectType
        }

        newObject.budget = category.budget as NSDecimalNumber
        newObject.title = category.title
    }

    private func expectedObject(for id: BudgetCategory.ID) throws -> BCBudgetCategory {
        let objectID = try convertToManagedObjectID(id)
        guard let expectedObject = try self.mainContext.existingObject(with: objectID) as? BCBudgetCategory else {
            throw Error.expectedObjectNotFound
        }

        return expectedObject
    }
}

extension BudgetCategoryCoreDataRepository {

    enum Error: Swift.Error {
        case wrongObjectType
        case unableToMakeObjectURLFromString
        case unableToGenerateObjectIDForURL
        case expectedObjectNotFound
    }
}

private extension BCBudgetCategory {

    enum FetchRequests {

        static func allCategoryListIDs() -> NSFetchRequest<NSManagedObjectID> {
            let request = NSFetchRequest<NSManagedObjectID>(entityName: BCBudgetCategory.className)
            request.resultType = .managedObjectIDResultType
            return request
        }

    }

    static func create(in context: NSManagedObjectContext) -> Self? {
        NSEntityDescription.insertNewObject(forEntityName: BCBudgetCategory.className, into: context) as? Self
    }

}
