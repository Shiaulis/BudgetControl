//
//  BCBudgetCategory+CoreDataProperties.swift
//  BudgetControl
//
//  Created by Andrius Shiaulis on 28.08.2023.
//
//

import Foundation
import CoreData

extension BCBudgetCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BCBudgetCategory> {
        return NSFetchRequest<BCBudgetCategory>(entityName: "BCBudgetCategory")
    }

    @NSManaged public var title: String
    @NSManaged public var budget: NSDecimalNumber
    @NSManaged public var spent: NSDecimalNumber

}

extension BCBudgetCategory: Identifiable {}
