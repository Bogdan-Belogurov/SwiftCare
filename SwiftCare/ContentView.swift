//
//  ContentView.swift
//  SwiftCare
//
//  Created by Bogdan Belogurov on 25/11/2023.
//

import SwiftUI

struct ContentView: View {

    @EnvironmentObject var appointmentsStore: AppointmentsStore

    private var rows: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    @State
    private var date = Date()
    @State
    private var calendarIsPresented = false
    @State
    private var wizardIsPresented = false
    @State
    private var selectedStatisticsPeriod = StatisticsPeriod.weak
    private let hourWidth = 150.0
    private let calendarHeight = 335.0

    private var totalEvents: Int {
        return appointmentsStore
            .appointments
            .filter {
                return Calendar.current.component(.weekOfYear, from: $0.startDate) ==
                Calendar.current.component(.weekOfYear, from: date)
            }
            .count
    }


    var body: some View {
        let appointment0 = getAppointment(machineID: 0)
        let appointment1 = getAppointment(machineID: 1)
        let appointment2 = getAppointment(machineID: 2)
        let appointment3 = getAppointment(machineID: 3)
        let appointment4 = getAppointment(machineID: 4)

        NavigationStack {
            ScrollView {
                HStack(alignment: .center, spacing: 8) {
                    VStack(alignment: .leading) {
                        Group {
                            VStack(alignment: .leading) {
                                Text("TrueBeam 1").bold()
                                Text("Load: \(appointment0.getLoadPercent(start: 7, end: 19))%")
                            }
                            VStack(alignment: .leading) {
                                Text("TrueBeam 2").bold()
                                Text("Load: \(appointment1.getLoadPercent(start: 7, end: 19))%")
                            }
                            VStack(alignment: .leading) {
                                Text("VitalBeam 1").bold()
                                Text("Load: \(appointment2.getLoadPercent(start: 7, end: 19))%")
                            }
                            VStack(alignment: .leading) {
                                Text("VitalBeam 2").bold()
                                Text("Load: \(appointment3.getLoadPercent(start: 7, end: 19))%")
                            }
                            VStack(alignment: .leading) {
                                Text("Unique").bold()
                                Text("Load: \(appointment4.getLoadPercent(start: 7, end: 19))%")
                            }
                        }
                        .font(.callout)
                        .opacity(0.8)
                        .padding(4)
                        .cornerRadius(8)
                    }
                    Divider()

                    ScrollView(.horizontal, showsIndicators: false) {
                        ZStack(alignment: .leading) {
                            HStack(alignment: .center, spacing: 0) {
                                ForEach(7..<19) { hour in
                                    VStack {
                                        Text("\(hour):00")
                                            .font(.caption)
                                            .frame(width: hourWidth, alignment: .leading)
                                        Color(red: 0.0, green: 1.0, blue: 1.0).opacity(hour % 2 == 0 ? 0.05 : 0)
                                            .cornerRadius(16)
                                            .frame(width: hourWidth, height: calendarHeight - 30)
                                    }
                                }
                            }


                            VStack(alignment: .leading, spacing: 18) {
                                ZStack(alignment: .leading) {
                                    ForEach(
                                        appointment0
                                    ) { appointment in
                                        appointmentCell(appointment, colour: WellKnownConstants.teal)
                                    }
                                }
                                ZStack(alignment: .leading) {
                                    ForEach(
                                        appointment1
                                    ) { appointment in
                                        appointmentCell(appointment, colour: WellKnownConstants.red)
                                    }
                                }
                                ZStack(alignment: .leading) {
                                    ForEach(
                                        appointment2
                                    ) { appointment in
                                        appointmentCell(appointment, colour: WellKnownConstants.white)
                                    }
                                }
                                ZStack(alignment: .leading) {
                                    ForEach(
                                        appointment3
                                    ) { appointment in
                                        appointmentCell(appointment, colour: WellKnownConstants.green)
                                    }
                                }

                                ZStack(alignment: .leading) {
                                    ForEach(
                                        appointment4
                                    ) { appointment in
                                        appointmentCell(appointment, colour: WellKnownConstants.orange)
                                    }
                                }
                            }

                            if let timeOffset = getCurrentTimeOffset() {
                                ZStack {
                                    Color.red.opacity(0.4)
                                        .frame(width: 1, height: calendarHeight)

                                    VStack {
                                        Circle()
                                            .fill(Color.red.opacity(0.4))
                                            .frame(width: 8, height: 8)
                                    }
                                }
                                .offset(x: timeOffset, y: 16)
                            }
                        }
                    }
                }
                .frame(height: calendarHeight)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.clear)
                )
                .padding(.horizontal, 16)

                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Weekly statistics")
                            .font(.title)
                            .opacity(0.8)

                        HStack(spacing: 56) {
                            VStack(alignment: .center, spacing: 16) {
                                ChartView(date: $date)
                                    .frame(width: 400)
                                    .padding()
                            }

                            VStack {
                                Text("Number of treatments:")
                                    .font(Font.headline)

                                Spacer()
                                HStack(alignment: .center, spacing: 32) {
                                    VStack(alignment: .leading, spacing: 16) {
                                        Text("\(totalEvents)")
                                            .font(.title)
                                            .bold()
                                        Text("TOTAL")
                                            .font(.caption)
                                            .foregroundColor(.black.opacity(0.5))
                                    }

                                    Divider()
                                        .frame(height: 50)

                                    VStack(alignment: .leading, spacing: 16) {
                                        Text("\(appointmentsStore.newEvents)")
                                            .font(.title)
                                            .bold()
                                        Text("NEW")
                                            .font(.caption)
                                            .foregroundColor(.black.opacity(0.5))
                                    }
                                }
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding()
                            .background(
                                LinearGradient(gradient: Gradient(colors: [.purple.opacity(0.05), .purple.opacity(0.2)]), startPoint: .topTrailing, endPoint: .bottomLeading)
                                )
                            .background()
                            .cornerRadius(16)
                        }
                    }
                    Spacer()
                }
                .padding(.top)
                .padding(.horizontal)

                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    VStack(alignment: .leading) {
                        Button {
                            calendarIsPresented.toggle()
                        } label: {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(date.formatted(.dateTime.day().month()))
                                        .bold()
                                    Text(date.formatted(.dateTime.year()))
                                }
                                .font(.title)
                                Text(date.formatted(.dateTime.weekday(.wide)))
                            }
                            .tint(.black.opacity(0.8))
                        }
                        .popover(isPresented: $calendarIsPresented) {
                            CalendarView(
                                interval:  DateInterval(start: .distantPast, end: .distantFuture),
                                appointmentsStore: appointmentsStore,
                                date: $date,
                                displayEvents: $calendarIsPresented
                            )
                            .background(.white)
                            .tint(.cyan)
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        wizardIsPresented.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "plus")
                            Text("Make new appointment")
                        }
                        .foregroundStyle(Color.white)
                        .padding(.all, 8)
                        .background(Color.purple.opacity(0.8))
                        .cornerRadius(8)
                    }
                }
            }
            .sheet(isPresented: $wizardIsPresented, onDismiss: {}) {
                NavigationStack {
                    EventWizardView(isPresented: $wizardIsPresented)
                }
                .presentationDetents([.fraction(0.45)])
            }
        }

    }

    private func getAppointment(machineID: Int) -> [Appointment] {
        let day = Calendar.current.component(.day, from: date)
        let month = Calendar.current.component(.month, from: date)
        return appointmentsStore
            .appointments
            .filter { appointment in
                return Calendar.current.component(.month, from: appointment.startDate) == month &&
                Calendar.current.component(.day, from: appointment.startDate) == day &&
                appointment.machineIndex == machineID
            }
    }

    private func appointmentCell(_ appointment: Appointment, colour: Color = .teal.opacity(0.5)) -> some View {
        let duration = appointment.endDate.timeIntervalSince(appointment.startDate)
        let width = duration / 60 / 60 * hourWidth

        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: appointment.startDate)
        let minute = calendar.component(.minute, from: appointment.startDate)
        let offset = Double(hour - 7) * (hourWidth) + Double(minute) / 60 * hourWidth

        return VStack(alignment: .leading) {
            Text(appointment.startDate.formatted(.dateTime.hour().minute()))
            Text(appointment.name).bold()
        }
        .font(.caption)
        .padding(4)
        .frame(width: width, alignment: .leading)
        .background(colour)
        .cornerRadius(8)
        .offset(x: offset, y: 0)
        .shadow(color: .black.opacity(0.2), radius: 2)
    }

    static func dateFrom(_ day: Int, _ month: Int, _ year: Int, _ hour: Int = 0, _ minute: Int = 0) -> Date {
        let calendar = Calendar.current
        let dateComponents = DateComponents(year: year, month: month, day: day, hour: hour, minute: minute)
        return calendar.date(from: dateComponents) ?? .now
    }

    func getCurrentTimeOffset() -> Double? {
        let currentDate = Date()
        let day = Calendar.current.component(.day, from: currentDate)
        let selectedDay = Calendar.current.component(.day, from: date)
        guard day == selectedDay else { return nil }
        let hour = Calendar.current.component(.hour, from: currentDate)
        let minute = Calendar.current.component(.minute, from: currentDate)
        return Double(hour - 7) * (hourWidth) + Double(minute) / 60 * hourWidth
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CalendarView: UIViewRepresentable {

    let interval: DateInterval
    @ObservedObject var appointmentsStore: AppointmentsStore
    @Binding var date: Date
    @Binding var displayEvents: Bool

    func makeUIView(context: Context) -> some UICalendarView {
        let view = UICalendarView()
        view.delegate = context.coordinator
        view.calendar = Calendar(identifier: .gregorian)
        view.availableDateRange = interval
        let dateSelection = UICalendarSelectionSingleDate(delegate: context.coordinator)
        view.selectionBehavior = dateSelection
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return view
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {}

    class Coordinator: NSObject, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {

        var parent: CalendarView
        @ObservedObject var appointmentsStore: AppointmentsStore
        init(parent: CalendarView) {
            self.parent = parent
            self.appointmentsStore = parent.appointmentsStore
        }

        @MainActor
        func calendarView(
            _ calendarView: UICalendarView,
            decorationFor dateComponents: DateComponents
        ) -> UICalendarView.Decoration? {
            guard let date = dateComponents.date else { return nil }
            let dayToRender = Calendar.current.component(.day, from: date)
            let monthToRender = Calendar.current.component(.month, from: date)

            let event = appointmentsStore
                .appointments
                .first {
                    Calendar.current.component(.day, from: $0.startDate) == dayToRender &&
                    Calendar.current.component(.month, from: $0.startDate) == monthToRender
                }

            guard event != nil else { return nil }
            return .default()
        }

        func dateSelection(_ selection: UICalendarSelectionSingleDate,
                           didSelectDate dateComponents: DateComponents?) {
            guard let date = dateComponents?.date else { return }
            parent.date = date
            parent.displayEvents.toggle()
        }

        func dateSelection(_ selection: UICalendarSelectionSingleDate,
                           canSelectDate dateComponents: DateComponents?) -> Bool {
            return true
        }
    }
}

struct Event: Identifiable {

    let id = UUID()
    let startDate: Date
    let endDate: Date
    let title: String
}
