//
//  CategoryDetailsViewController.swift
//  BudgetControl
//
//  Created by Andrius Shiaulis on 08.09.2023.
//

import SwiftUI

final class CategoryDetailsViewController: UIHostingController<CategoryDetailsView> {

    // MARK: - Init

    init(viewModel: CategoryDetailsViewModel) {
        super.init(rootView: CategoryDetailsView(viewModel: viewModel))
    }

    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

struct CategoryDetailsView: View {

    let viewModel: CategoryDetailsViewModel

    var body: some View {
        Text(self.viewModel.title)
    }

}
