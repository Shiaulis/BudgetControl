//
//  FinanceConverterService.swift
//  BudgetControl
//
//  Created by Andrius Shiaulis on 29.08.2023.
//

import Foundation
import UIKit

struct FinanceConverterService {

    // MARK: - Properties -

    private static let defaultCurrencyCode = "EUR"

    private var localCurrencyCode: String {
        Locale.current.currency?.identifier ?? Self.defaultCurrencyCode
    }

    // MARK: - Public API -

    func makeCurrencyString(from decimal: Decimal) -> String? {
        decimal.formatted(.currency(code: self.localCurrencyCode))
    }

    func makeDecimal(from string: String) -> Decimal? {
        try? Decimal(string, strategy: Decimal.ParseStrategy(format: .currency(code: localCurrencyCode)))
    }

}

private extension Decimal {

    var doubleValue: Double {
        NSDecimalNumber(decimal: self).doubleValue
    }

}

private extension Double {

    var decimalValue: Decimal {
        NSNumber(value: self).decimalValue
    }

}
