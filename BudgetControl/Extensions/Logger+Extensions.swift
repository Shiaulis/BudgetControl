//
//  Logger+Extensions.swift
//  BudgetControl
//
//  Created by Andrius Shiaulis on 28.08.2023.
//

import Foundation
import OSLog

extension Logger {
    private static var bundleIdentifier: String { Bundle.main.bundleIdentifier ?? "com.shiaulis.BudgetControl" }

    /// Convenient init that is using main bundle identifier as subsystem and reporter type as category
    init<Reporter>(reporterType: Reporter.Type) {
        self.init(subsystem: Self.bundleIdentifier, category: String(describing: reporterType.self))
    }
}
