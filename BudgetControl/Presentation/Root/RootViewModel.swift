//
//  RootViewModel.swift
//  BudgetControl
//
//  Created by Andrius Shiaulis on 26.08.2023.
//

import Foundation
import Combine

enum RootViewModelRouteCommand {
    case categoryDetails
    case categoryCreation(CategoryCreationViewModel)
    case dismiss
    case categoryList
}

protocol RootViewModel {

    var show: AnyPublisher<RootViewModelRouteCommand?, Never> { get }

    func makeCategoryListViewModel() -> CategoryListViewModel
    func makeCategoryDetailsViewModel() -> CategoryDetailsViewModel

}

protocol CategoryListItemViewModel {

    var title: String { get }

}
