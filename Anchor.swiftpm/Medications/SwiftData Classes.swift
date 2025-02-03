//
//  Medication.swift
//  Anchor
//
//  Created by Morris Richman on 2/2/25.
//

import Foundation
import SwiftData

@Model
class Medication {
    var name: String
    var dosage: String
    
    init(name: String, dosage: String) {
        self.name = name
        self.dosage = dosage
    }
}

@Model
class MedicationLog: Identifiable {
    var id: UUID = UUID()
    var date: Date
    var medications: [Medication]
    
    init(date: Date, medications: [Medication]) {
        self.date = date
        self.medications = medications
    }
}
