//
//  Date+Extensions.swift
//  BudgetControl
//
//  Created by Andrius Shiaulis on 01.09.2023.
//

import Foundation

extension Date {

    func startOfMonth(in calendar: Calendar = .current) -> Date? {
        let startOfDay = calendar.startOfDay(for: self)
        let dateComponentsForTodayStartTime = calendar.dateComponents([.year, .month], from: startOfDay)

        return calendar.date(from: dateComponentsForTodayStartTime)
    }

    func endOfMonth(in calendar: Calendar = .current) -> Date? {
        guard let startOfMonth = startOfMonth(in: calendar) else {
            return nil
        }

        let dayBeforeNextMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)
        return dayBeforeNextMonth
    }

}
