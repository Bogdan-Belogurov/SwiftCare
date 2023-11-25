//
//  EventWizardView.swift
//  SwiftCare
//
//  Created by Artem Burmistrov on 25.11.2023.
//

import SwiftUI

struct EventWizardView: View {

    @Binding
    var isPresented: Bool
    @State
    private var name = String()
    @State
    private var cancerType: CancerType = .lung
    @State
    private var daysInRow = CancerType.lung.daysInRowOptions.first!
    @State
    private var appointmentIsSaving = false

    var canBeSaved: Bool {
        return !(name.isEmpty || name.allSatisfy { $0.isWhitespace })
    }

    var body: some View {
        Form {
            TextField("Appointment title", text: $name)
            Picker("Cancer type", systemImage: "cross.fill", selection: $cancerType) {
                ForEach(CancerType.allCases, id: \.self) {
                    Text($0.description)
                }
            }
            Picker("Fraction", systemImage: "calendar", selection: $daysInRow) {
                ForEach(cancerType.daysInRowOptions, id: \.self) {
                    if $0 == 1 {
                        Text("\($0) day")
                    } else {
                        Text("\($0) days")
                    }
                }
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 16) {
            Button {
                guard !appointmentIsSaving else { return }
                Task {
                    if canBeSaved {
                        appointmentIsSaving = true
                        try await NetworkService.shared.addAppointment(
                            NewAppointmentData(
                                name: name,
                                cancerType: cancerType,
                                daysInRow: daysInRow,
                                patientID: UUID())
                        )
                        appointmentIsSaving = false
                    }
                    isPresented.toggle()
                }
            } label: {
                HStack {
                    if appointmentIsSaving {
                        ProgressView()
                    } else if canBeSaved {
                        Image(systemName: "doc.text.below.ecg.fill")
                        Text("Make an appointment")
                    } else {
                        Text("Cancel")
                    }
                }
                .foregroundStyle(Color.white)
                .frame(height: 47)
                .frame(maxWidth: .infinity)
                .cornerRadius(8)
            }
            .background(canBeSaved ? .blue : .red)
            .cornerRadius(8)
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("New appointment")
    }
}
