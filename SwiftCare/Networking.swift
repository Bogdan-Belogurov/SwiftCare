//
//  Networking.swift
//  SwiftCare
//
//  Created by Artem Burmistrov on 25.11.2023.
//

import Foundation

struct Appointment: Codable {

    private(set) var id: UUID
    var name: String
    let startDate: Date
    let machineIndex: Int
    var patientID: UUID?

    init(_ appointment: Appointment) {
        id = appointment.id
        name = appointment.name
        startDate = appointment.startDate
        machineIndex = appointment.machineIndex
        patientID = appointment.patientID
    }
}

enum CancerType: String, Codable {

    case craniospinal
    case breast
    case breastSpecial
    case headAndNeck
    case abdomen
    case pelvis
    case crane
    case lung
    case lungSpecial
    case wholeBrain
}

struct NewAppointmentData: Codable {

    let name: String
    let cancerType: CancerType
    let daysInRow: Int
    let patientID: UUID
}

final class NetworkService {

    static let shared = NetworkService()

    private init() {}

    func getAppointments(from dateFrom: Date, to dateTo: Date) async throws -> [Appointment] {
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = "localhost"
        urlComponents.port = 8080
        urlComponents.path = "/api/events"
        urlComponents.queryItems = [
            URLQueryItem(name: "startDate", value: dateFrom.formatted(.iso8601)),
            URLQueryItem(name: "endDate", value: dateTo.formatted(.iso8601))
        ]
        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
            throw URLError(.badServerResponse)
        }

        return try decoder.decode([Appointment].self, from: data)
    }

    func addAppointment(_ newData: NewAppointmentData) async throws {
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = "localhost"
        urlComponents.port = 8080
        urlComponents.path = "/api/events"
        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(newData)

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
            throw URLError(.badServerResponse)
        }
    }
}
