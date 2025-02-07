//
//  Medication.swift
//  Anchor
//
//  Created by Morris Richman on 2/2/25.
//

import Foundation
import SwiftData
import Combine

extension NotificationCenter {
    var modelContextDidSavePublisher: Publishers.ReceiveOn<NotificationCenter.Publisher, DispatchQueue> {
        return publisher(for: ModelContext.didSave, object: nil).receive(on: DispatchQueue.main)
    }
}

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
class MedicationLogMedArrayElement {
    var isTaken: Bool
    
    @Relationship(deleteRule: .cascade)
    var medication: MedicationLogMed
    
    init(isTaken: Bool, medication: MedicationLogMed) {
        self.isTaken = isTaken
        self.medication = medication
    }
}

@Model
class MedicationLog: Identifiable {
    var id: UUID = UUID()
    var date: Date
    
    @Relationship(deleteRule: .cascade)
    var medications: [MedicationLogMedArrayElement]
    
    var takenMedications: [MedicationLogMed] {
        medications.filter { $0.isTaken }.map({ $0.medication })
    }
    
    init(date: Date, medications: [MedicationLogMedArrayElement]) {
        self.date = date
        self.medications = medications
    }
    
    @MainActor static var blank: MedicationLog { .init(date: .now, medications: []) }
}

@Model
class MedicationLogMed: Identifiable {
    var name: String
    var dosage: String
    var quantity: Int
    var notes: String
    private(set) var underlyingMedication: Medication?
    
    init(name: String, dosage: String, quantity: Int, notes: String, underlyingMedication: Medication?) {
        self.name = name
        self.dosage = dosage
        self.quantity = quantity
        self.notes = notes
        self.underlyingMedication = underlyingMedication
    }
    
    init(from medication: Medication) {
        self.name = medication.name
        self.dosage = medication.dosage
        self.quantity = medication.quantity ?? 1
        self.notes = medication.notes
        self.underlyingMedication = medication
    }
}
