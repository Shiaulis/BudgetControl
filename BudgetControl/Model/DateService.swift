//
//  DateService.swift
//  BudgetControl
//
//  Created by Andrius Shiaulis on 01.09.2023.
//

import Foundation
import Combine

typealias ChunkNumber = Int

protocol DateService {

    func numberOfChunksInCurrentMonth () -> Int
    func makeChunksPublisher() -> AnyPublisher<ChunkNumber, DateServiceError>

}

enum DateServiceError: Error {
    // swiftlint:disable:next identifier_name
    case unableToCalculateChunkDifferenceBetweenDates
    case unableToGetStartOfMonthDate
    case unknown
}

final class SecondsDateService: DateService {

    // MARK: - Properties -

    private let calendar: Calendar = .current
    private let timer: Timer = .init()

    // MARK: - Public API -

    func numberOfChunksInCurrentMonth() -> Int {
        self.calendar.range(of: .second, in: .month, for: .now)?.count ?? 0
    }

    func makeChunksPublisher() -> AnyPublisher<ChunkNumber, DateServiceError> {
        Timer.publish(every: 1, on: .current, in: .default)
            .autoconnect()
            .tryMap { [weak self] _ -> Int in
                guard let self else { return 0 }
                let now = Date.now
                let startOfMonth = try self.calculateStartOfMonth(for: now)

                let seconds = try calculateSecondsDifferenceBetween(start: startOfMonth, end: now)
                return seconds
            }
            .mapError { error in
                switch error {
                case let dateServiceError as DateServiceError: return dateServiceError
                default: return .unknown
                }
            }

            .eraseToAnyPublisher()
    }

    private func calculateSecondsDifferenceBetween(start: Date, end: Date) throws -> Int {
        guard let seconds = self.calendar.dateComponents([.second], from: start, to: end).second else {
            throw DateServiceError.unableToCalculateChunkDifferenceBetweenDates
        }

        return seconds
    }

    private func calculateStartOfMonth(for date: Date) throws -> Date {
        guard let startOfMonth = date.startOfMonth(in: self.calendar) else {
            throw DateServiceError.unableToGetStartOfMonthDate
        }

        return startOfMonth
    }

}
