//
//  UIBarButtonItem+Extensions.swift
//  BudgetControl
//
//  Created by Andrius Shiaulis on 28.08.2023.
//

import UIKit

extension UIBarButtonItem {
    static func systemActionItem(_ item: UIBarButtonItem.SystemItem, handler: @escaping () -> Void) -> UIBarButtonItem {
        let primaryAction = UIAction { _ in
            handler()
        }

        return .init(systemItem: item, primaryAction: primaryAction)
    }
}
