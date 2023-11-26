//
//  MonthDataSet.swift
//  SwiftCare
//
//  Created by Bogdan Belogurov on 26/11/2023.
//

import Foundation

struct MonthDataSet: Hashable, Comparable {

    let startDate: Date
    let duration: Double
    let machineIndex: Int
    
    var machineName: String {
        switch machineIndex {
        case 0:
            return "TrueBeam 1"
        case 1:
            return "TrueBeam 2"
        case 2:
            return "VitalBeam 1"
        case 3:
            return "VitalBeam 2"
        default:
            return "Unique"
        }
    }

    static func < (lhs: MonthDataSet, rhs: MonthDataSet) -> Bool {
        return lhs.machineIndex < rhs.machineIndex
    }
}
