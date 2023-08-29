//
//  BudgetConverter.swift
//  BudgetControl
//
//  Created by Andrius Shiaulis on 29.08.2023.
//

import Foundation

struct BudgetConverter {

    private static let defaultCurrencyCode = "EUR"
    private var localCurrencyCode: String {
        Locale.current.currency?.identifier ?? Self.defaultCurrencyCode
    }

    func makeCurrencyString(from decimal: Decimal) -> String {
        decimal.formatted(.currency(code: localCurrencyCode))
    }

    func makeDecimal(from string: String) -> Decimal? {
        try? Decimal(string, strategy: Decimal.ParseStrategy(format: .currency(code: localCurrencyCode)))
    }

}
