//
//  Array+.swift
//  SwiftCare
//
//  Created by Bogdan Belogurov on 25/11/2023.
//

import Foundation

extension Array where Element == Appointment {


    /// Returns machine usage  percent
    /// - Parameters:
    ///   - start: Start of work in hours
    ///   - end: End of work in hours
    func getLoadPercent(start: Int, end: Int) -> Int {
        let availableTime = end - start
        let totalTime = map { $0.startDate.distance(to: $0.endDate)}
            .reduce(0, +) / 60 / 60
        guard availableTime > 0, totalTime > 0 else { return .zero }
        return Int(totalTime / Double(availableTime) * 100)
    }

    func getMonthDataSet(selectedDate: Date) -> [MonthDataSet] {
        let week = Calendar.current.component(.weekOfYear, from: selectedDate)
        let appointments = filter { Calendar.current.component(.weekOfYear, from: $0.startDate) == week }
        let result = Dictionary(grouping: appointments) { Calendar.current.component(.day, from: $0.startDate) }
            .flatMap { _, appointments in
                return Dictionary(grouping: appointments, by: \.machineIndex)
                    .map { (key, appointments) -> MonthDataSet in
                        let totalDuration = appointments
                            .map { $0.startDate.distance(to: $0.endDate)}
                            .reduce(0, +) / 60 / 60
                        return MonthDataSet(
                            startDate: appointments.first?.startDate ?? Date(),
                            duration: totalDuration,
                            machineIndex: key
                        )
                    }
                    .sorted()
            }
        return result
    }
}
