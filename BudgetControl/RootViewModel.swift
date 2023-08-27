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
}

protocol RootViewModel {

    var show: any Publisher<RootViewModelRouteCommand?, Never> { get }

    func makeCategoryListViewModel() -> CategoryListViewModel

}

protocol CategoryListItemViewModel {

    var title: String { get }

}

protocol CategoryDetailsViewModel {

    var title: String { get }

}
