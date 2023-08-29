//
//  CategoryDetailsController.swift
//  BudgetControl
//
//  Created by Andrius Shiaulis on 28.08.2023.
//

import Foundation
import Combine
import OSLog

final class CategoryDetailsController: CategoryDetailsViewModel {

    // MARK: - Properties -

    @Published var controllerState: CategoryDetailsState = .empty
    @Published var categoryID: BudgetCategory.ID?

    var completion: (() -> Void)?

    private let model: BudgetModel
    private var disposables: Set<AnyCancellable> = []
    private lazy var logger: Logger = .init(reporterType: Self.self)

    // MARK: - Init -

    init(model: BudgetModel) {
        self.model = model

        bindCategoryID()
    }

    // MARK: - Public API

    var state: AnyPublisher<CategoryDetailsState, Never> {
        self.$controllerState.eraseToAnyPublisher()
    }

    func delete() {
        guard let categoryID else {
            self.logger.error("Attempt to delete category without objectID")
            assertionFailure()
            return
        }

        self.model.deleteCategory(by: categoryID)
        self.completion?()
    }

    // MARK: - Private -

    private func bindCategoryID() {
        self.$categoryID
            .sink { [weak self] id in
                guard let self else { return }

                guard let id else {
                    // we assume the state is empty for `nil` ID
                    self.controllerState = .empty
                    return
                }

                guard let category = self.model.getCategory(by: id) else {
                    self.logger.error("Cannot get category for ID: \(id)")
                    assertionFailure()
                    self.controllerState = .error
                    return
                }

                let detailsConfiguration = mapConfiguration(from: category)
                self.controllerState = .details(detailsConfiguration)
            }
            .store(in: &self.disposables)
    }

    private func mapConfiguration(from category: BudgetCategory) -> CategoryDetailsConfiguration {
        .init(
            title: category.title,
            budget: BudgetConverter().makeCurrencyString(from: category.budget),
            isDeleteEnabled: true
        )
    }

}
