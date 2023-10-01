//
//  CategoryDetailsViewModel.swift
//  BudgetControl
//
//  Created by Andrius Shiaulis on 01.10.2023.
//

import Foundation

struct CategoryDetailsViewModel {

    // MARK: - Properties -

    let title: String
    let budget: String
    let isDeleteEnabled: Bool

    // MARK: - Init -

    init(title: String, budget: String, isDeleteEnabled: Bool) {
        self.title = title
        self.budget = budget
        self.isDeleteEnabled = isDeleteEnabled
    }

    func delete() {}

    var totalBudget: String {
        "test"
    }

    var spentBudget: String {
        "test"
    }

    func edit() {}

}
