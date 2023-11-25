//
//  SwiftCareApp.swift
//  SwiftCare
//
//  Created by Bogdan Belogurov on 25/11/2023.
//

import SwiftUI

@main
struct SwiftCareApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    Task {
                        let networking = NetworkService.shared
                        try await networking.addAppointment(
                            NewAppointmentData(name: "Vovan", cancerType: .lung, daysInRow: 10, patientID: UUID())
                        )
                        print(try await networking.getAppointments(from: .distantPast, to: .distantFuture))
                    }
                }
        }
    }
}
