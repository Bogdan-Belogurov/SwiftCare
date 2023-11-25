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

enum CancerType: String, Codable, Hashable, CaseIterable, CustomStringConvertible {

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

    var description: String {
        switch self {
        case .craniospinal:
            return "Craniospinal"
        case .breast:
            return "Breast"
        case .breastSpecial:
            return "Breast special"
        case .headAndNeck:
            return "Head and neck"
        case .abdomen:
            return "Abdomen"
        case .pelvis:
            return "Pelvis"
        case .crane:
            return "Crane"
        case .lung:
            return "Lung"
        case .lungSpecial:
            return "Lung special"
        case .wholeBrain:
            return "Whole brain"
        }
    }

    var daysInRowOptions: [Int] {
        switch self {
        case .craniospinal:
            return [13, 17, 20, 30]
        case .breast, .breastSpecial:
            return [15, 19, 25, 30]
        case .headAndNeck:
            return [5, 10, 15, 25, 30, 33, 35]
        case .abdomen:
            return [1, 3, 5, 8, 10, 12, 15, 18, 20, 30]
        case .pelvis:
            return [1, 3, 5, 10, 15, 22, 23, 25, 28, 35]
        case .crane:
            return [1, 5, 10, 13, 25, 30]
        case .lung:
            return [1, 5, 10, 15, 20, 25, 30, 33]
        case .lungSpecial:
            return [3, 5, 8]
        case .wholeBrain:
            return [5, 10, 12]
        }
    }
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
