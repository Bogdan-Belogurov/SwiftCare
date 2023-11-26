//
//  SwiftCareApp.swift
//  SwiftCare
//
//  Created by Bogdan Belogurov on 25/11/2023.
//

import SwiftUI

@main
struct SwiftCareApp: App {

    @StateObject var appointmentsStore = AppointmentsStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appointmentsStore)
                .onAppear {
                    Task {
                        try await appointmentsStore.fetchAppointments()
                        try await UNUserNotificationCenter
                            .current()
                            .requestAuthorization(options:  [.alert, .badge, .sound])
                    }
                }
        }
    }
}
