//
//  RootViewModel.swift
//  BudgetControl
//
//  Created by Andrius Shiaulis on 26.08.2023.
//

import Foundation
import Combine

protocol RootViewModel {

    var selectedCategoryDetailsViewModel: any Publisher<CategoryDetailsViewModel?, Never> { get }

    func makeCategoryListViewModel() -> CategoryListViewModel

}

protocol CategoryListViewModel {

    var categories: any Publisher<[BudgetCategory.ID], Never> { get }

    func didSelectCategory(_ id: BudgetCategory.ID)
    func getCategory(for id: BudgetCategory.ID) -> BudgetCategory?

}

protocol CategoryListItemViewModel {

    var title: String { get }

}

protocol CategoryDetailsViewModel {

    var title: String { get }

}
