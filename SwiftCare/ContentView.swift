//
//  ContentView.swift
//  SwiftCare
//
//  Created by Bogdan Belogurov on 25/11/2023.
//

import SwiftUI

struct ContentView: View {

    @State private var displayEvents = false

    let events: [Event] = [
        Event(startDate: dateFrom(9,5,2023,7,0), endDate: dateFrom(9,5,2023,7,30), title: "Event 1"),
        Event(startDate: dateFrom(9,5,2023,9,0), endDate: dateFrom(9,5,2023,10,0), title: "Event 2"),
        Event(startDate: dateFrom(9,5,2023,11,0), endDate: dateFrom(9,5,2023,12,00), title: "Event 3"),
        Event(startDate: dateFrom(9,5,2023,13,0), endDate: dateFrom(9,5,2023,14,45), title: "Event 4"),
        Event(startDate: dateFrom(9,5,2023,15,0), endDate: dateFrom(9,5,2023,15,45), title: "Event 5"),
    ]

    var rows: [GridItem] = [
        GridItem(.fixed(100)),
        GridItem(.fixed(100)),
        GridItem(.fixed(100)),
        GridItem(.fixed(100))
    ]

    @State
    private var date = Date()
    @State
    private var calendarIsPresented = false
    @State
    private var wizardIsPresented = false
    private let hourWidth = 150.0

    var body: some View {
        GeometryReader { proxy in
            let height = proxy.size.height * 0.45
            NavigationStack {
                ScrollView {
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
                                date: $date,
                                displayEvents: $displayEvents
                            )
                            .background(.white)
                            .tint(.cyan)
                        }

                        HStack(alignment: .center, spacing: 8) {
                            VStack(alignment: .leading) {
                                Group {
                                    VStack(alignment: .leading) {
                                        Text("1 Machine")
                                        Text("Load: 45%").bold()
                                    }
                                    VStack(alignment: .leading) {
                                        Text("1 Machine")
                                        Text("Load: 45%").bold()
                                    }
                                    VStack(alignment: .leading) {
                                        Text("1 Machine")
                                        Text("Load: 45%").bold()
                                    }
                                    VStack(alignment: .leading) {
                                        Text("1 Machine")
                                        Text("Load: 45%").bold()
                                    }
                                    VStack(alignment: .leading) {
                                        Text("1 Machine")
                                        Text("Load: 45%").bold()
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
                                                Color(red: 0.0, green: 1.0, blue: 1.0).opacity(hour % 2 == 0 ? 0.1 : 0)
                                                    .cornerRadius(16)
                                                    .frame(width: hourWidth, height: height - 30)
                                            }
                                        }
                                    }


                                    VStack(alignment: .leading, spacing: 18) {
                                        ZStack(alignment: .leading) {
                                            ForEach(events) { event in
                                                eventCell(event)
                                            }
                                        }
                                        ZStack(alignment: .leading) {
                                            ForEach(events) { event in
                                                eventCell(event, colour: .red.opacity(0.5))
                                            }
                                        }
                                        ZStack(alignment: .leading) {
                                            ForEach(events) { event in
                                                eventCell(event, colour: .white)
                                            }
                                        }
                                        ZStack(alignment: .leading) {
                                            ForEach(events) { event in
                                                eventCell(event, colour: .green.opacity(0.5))
                                            }
                                        }

                                        ZStack(alignment: .leading) {
                                            ForEach(events) { event in
                                                eventCell(event)
                                            }
                                        }
                                    }

                                    if let timeOffset = getCurrentTimeOffset() {
                                        ZStack {
                                            Color.red.opacity(0.4)
                                                .frame(width: 1, height: height)

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
                        .frame(height: height)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.white)
                        )
                        Spacer()
                    }
                    .padding()
                    Spacer()
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            wizardIsPresented.toggle()
                        } label: {
                            HStack {
                                Image(systemName: "plus")
                                Text("Make new appointment")
                            }
                            .foregroundStyle(Color.white)
                            .padding(.all, 8)
                            .background(Color.purple)
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
    }

    func eventCell(_ event: Event, colour: Color = .teal.opacity(0.5)) -> some View {
        let duration = event.endDate.timeIntervalSince(event.startDate)
        let width = duration / 60 / 60 * hourWidth

        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: event.startDate)
        let minute = calendar.component(.minute, from: event.startDate)
        let offset = Double(hour - 7) * (hourWidth) + Double(minute/60) * hourWidth

        return VStack(alignment: .leading) {
            Text(event.startDate.formatted(.dateTime.hour().minute()))
            Text(event.title).bold()
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
        return Double(8 - 7) * (hourWidth) + Double(minute/60) * hourWidth
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CalendarView: UIViewRepresentable {
    let interval: DateInterval
    //    @ObservedObject var eventStore: EventStore
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

    func updateUIView(_ uiView: UIViewType, context: Context) {
        //        if let changedEvent = eventStore.changedEvent {
        //            uiView.reloadDecorations(forDateComponents: [changedEvent.dateComponents], animated: true)
        //            eventStore.changedEvent = nil
        //        }
        //
        //        if let movedEvent = eventStore.movedEvent {
        //            uiView.reloadDecorations(forDateComponents: [movedEvent.dateComponents], animated: true)
        //            eventStore.movedEvent = nil
        //        }
    }

    class Coordinator: NSObject, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
        var parent: CalendarView
        //        @ObservedObject var eventStore: EventStore
        init(parent: CalendarView) {
            self.parent = parent
            //            self._eventStore = eventStore
        }

        @MainActor
        func calendarView(_ calendarView: UICalendarView,
                          decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
            //            let foundEvents = eventStore.events
            //                .filter {$0.date.startOfDay == dateComponents.date?.startOfDay}
            //            if foundEvents.isEmpty { return nil }
            //
            //            if foundEvents.count > 1 {
            //                return .image(UIImage(systemName: "doc.on.doc.fill"),
            //                              color: .red,
            //                              size: .large)
            //            }
            //            let singleEvent = foundEvents.first!
            //            return .customView {
            //                let icon = UILabel()
            //                icon.text = singleEvent.eventType.icon
            //                return icon
            //            }
//            return .default(color: [UIColor.red, .clear, .green , .orange].randomElement() ?? .clear)
            return .customView {
                let label = UILabel()
                label.text = ["🚨", "⚠️", ""].randomElement() ?? ""
                return label
            }
        }

        func dateSelection(_ selection: UICalendarSelectionSingleDate,
                           didSelectDate dateComponents: DateComponents?) {
            guard let date = dateComponents?.date else { return }
            parent.date = date
            //            let foundEvents = eventStore.events
            //                .filter {$0.date.startOfDay == dateComponents.date?.startOfDay}
            //            if !foundEvents.isEmpty {
            //                parent.displayEvents.toggle()
            //            }
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
