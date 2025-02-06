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
    var quantity: Int?
    var notes: String
    
    init(name: String, dosage: String, quantity: Int?, notes: String) {
        self.name = name
        self.dosage = dosage
        self.quantity = quantity
        self.notes = notes
    }
    
    @MainActor static var blank: Medication { .init(name: "", dosage: "", quantity: 1, notes: "") }
}

@Model
class MedicationLog: Identifiable {
    var id: UUID = UUID()
    var date: Date
    var medications: [Medication]
    var medicationQuantities: [PersistentIdentifier : Int]?
    
    init(date: Date, medications: [Medication], medicationQuantities: [PersistentIdentifier : Int]) {
        self.date = date
        self.medications = medications
        self.medicationQuantities = medicationQuantities
    }
    
    private init(date: Date, medications: [Medication], medicationQuantities: [PersistentIdentifier : Int]?) {
        self.date = date
        self.medications = medications
        self.medicationQuantities = medicationQuantities
    }
    
    func copy() -> MedicationLog {
        .init(date: date, medications: medications, medicationQuantities: medicationQuantities)
    }
    
    @MainActor static var blank: MedicationLog { .init(date: .now, medications: [], medicationQuantities: [:]) }
}
