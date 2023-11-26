//
//  WellKnownConstants.swift
//  SwiftCare
//
//  Created by Bogdan Belogurov on 26/11/2023.
//

import SwiftUI

enum WellKnownConstants {

    static let teal = Color.teal.opacity(0.5)
    static let red = Color.red.opacity(0.5)
    static let white = Color(hex: 0xEFEFEF)
    static let green = Color.green.opacity(0.5)
    static let orange = Color.orange.opacity(0.5)
}

extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 8) & 0xff) / 255,
            blue: Double(hex & 0xff) / 255,
            opacity: alpha
        )
    }
}
