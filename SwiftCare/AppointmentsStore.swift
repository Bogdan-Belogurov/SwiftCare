//
//  AppointmentsStore.swift
//  SwiftCare
//
//  Created by Bogdan Belogurov on 26/11/2023.
//

import SwiftUI

@MainActor
final class AppointmentsStore: ObservableObject {

    private let networking = NetworkService.shared
    @Published var appointments = [Appointment]()
    @Published var newEvents = 0

    func fetchAppointments() async throws {
        let appointments = try await networking.getAppointments(from: .distantPast, to: .distantFuture)
        self.appointments = appointments
    }

    func createAppointments(_ appointment: NewAppointmentData) async throws {
        try await networking.addAppointment(appointment)
        try await fetchAppointments()
        newEvents += appointment.daysInRow

        let content = UNMutableNotificationContent()
        content.title = "The treatment was scheduled successfully"
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        try await UNUserNotificationCenter.current().add(request)
    }
}
