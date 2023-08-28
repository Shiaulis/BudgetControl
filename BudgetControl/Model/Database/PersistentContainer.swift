//
//  PersistentContainer.swift
//  BudgetControl
//
//  Created by Andrius Shiaulis on 28.08.2023.
//

import Foundation
import CoreData
import OSLog

final class PersistentContainer: NSPersistentContainer {

    // MARK: - Properties

    private lazy var logger: Logger = .init(reporterType: Self.self)

    // MARK: - Init -

    init() {
        guard let modelURL = Bundle.main.url(forResource: "BudgetControl", withExtension: "momd") else {
            fatalError("Failed to find data model")
        }
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Failed to create model from file: \(modelURL)")
        }

        super.init(name: "BudgetControl", managedObjectModel: model)

        loadPersistentStores { [weak self] _, error in
            guard let self else { return }
            if let error {
                fatalError("Failed to load persistent store. Error: \(error.localizedDescription)")
            }

            self.logger.log("Persistent container stores were loaded successfully")
        }
    }

}
