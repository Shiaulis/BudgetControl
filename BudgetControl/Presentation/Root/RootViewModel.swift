//
//  RootViewModel.swift
//  BudgetControl
//
//  Created by Andrius Shiaulis on 26.08.2023.
//

import Foundation
import Combine

enum RootViewModelRouteCommand {
    case categoryDetails(CategoryDetailsViewModel?)
    case categoryCreation(CategoryCreationViewModel)
    case dismiss
}

protocol RootViewModel {

    var show: AnyPublisher<RootViewModelRouteCommand?, Never> { get }

    func makeCategoryListViewModel() -> CategoryListViewModel

}

protocol CategoryListItemViewModel {

    var title: String { get }

}

protocol CategoryDetailsViewModel {

    var title: String { get }

}
