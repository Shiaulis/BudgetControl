//
//  EmptyDetailsViewController.swift
//  BudgetControl
//
//  Created by Andrius Shiaulis on 08.09.2023.
//

import SwiftUI

final class EmptyDetailsViewController: UIHostingController<EmptyDetailsView> {

    // MARK: - Init -

    init() {
        super.init(rootView: EmptyDetailsView())
    }

    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

struct EmptyDetailsView: View {

    var body: some View {
        Text("Empty")
    }

}
