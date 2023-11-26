//
//  ChartView.swift
//  SwiftCare
//
//  Created by Bogdan Belogurov on 25/11/2023.
//

import SwiftUI
import Charts

enum StatisticsPeriod: CaseIterable {

    case day
    case weak
    case month

    var title: String {
        switch self {
        case .day:
            return "Day"
        case .weak:
            return "Weak"
        case .month:
            return "Month"
        }
    }
}
struct ChartView: View {

    @EnvironmentObject var appointmentsStore: AppointmentsStore
    @Binding var date: Date

    private var data: [MonthDataSet] {
        return appointmentsStore.appointments.getMonthDataSet(selectedDate: date)
    }

    var body: some View {
        Chart {
            ForEach(data, id: \.self) { dataSet in
                BarMark(
                    x: .value("date", dataSet.startDate, unit: .weekday),
                    y: .value("duration", dataSet.duration)
                )
                .foregroundStyle(by: .value("Machine",  dataSet.machineName))
            }
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .day)) { _ in
                AxisGridLine()
                AxisTick()
                AxisValueLabel(format: .dateTime.weekday(.abbreviated), centered: true)
            }
        }
        .chartForegroundStyleScale(
            [
                "TrueBeam 1": WellKnownConstants.teal,
                "TrueBeam 2": WellKnownConstants.red,
                "VitalBeam 1": WellKnownConstants.white,
                "VitalBeam 2": WellKnownConstants.green,
                "Unique": WellKnownConstants.orange
            ]
        )
    }
}

