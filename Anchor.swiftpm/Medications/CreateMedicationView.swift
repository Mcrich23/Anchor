//
//  CreateMedicationView.swift
//  Anchor
//
//  Created by Morris Richman on 2/2/25.
//

import SwiftUI

private enum CreateMedicationViewSteps: Int, ViewSteps {
    case name
    case dosage
}

@Observable
private final class CreateMedStepManager {
    private(set) var step: CreateMedicationViewSteps = .name
    var isBack = false
    
    func next() {
        isBack = false
        withAnimation {
            step.next()
        }
    }
    func previous() {
        isBack = true
        withAnimation {
            step.previous()
        }
    }
}

struct CreateMedicationView: View {
    @State private var stepManager = CreateMedStepManager()
    @Bindable var medication: Medication
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Image(systemName: "pill.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 150, maxHeight: 150)
                .symbolRenderingMode(.multicolor)
                .foregroundStyle(.pink)
            
            Text("Add Medication")
                .font(.largeTitle)
                .bold()
            GroupBox {
                TextField("Name", text: $medication.name)
            }
            GroupBox {
                TextEditor(text: $medication.notes)
                    .scrollContentBackground(.hidden)
                    .overlay(alignment: .topLeading) {
                        if medication.notes.isEmpty {
                            Text("Notes")
                                .foregroundStyle(.tertiary)
                                .padding(.leading, 5)
                                .padding(.top, 8.5)
                        }
                    }
                    .padding(-5)
            }
            
            Spacer()
            
            NavigationLink {
                CreateMedicationDosageView(dismissSheet: dismiss, medication: medication)
            } label: {
                Text("Continue")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .toolbar(content: {
            Button("Cancel") {
                dismiss()
            }
        })
    }
}

private enum CreateMedicationDosageUnit: String, CaseIterable {
    case mg
    case mcg
    case g
    case mL
    case percent = "%"
}

private struct CreateMedicationDosageView: View {
    let dismissSheet: DismissAction
    @Bindable var medication: Medication
    @State private var unit = CreateMedicationDosageUnit.mg
    @State private var dosage = ""
    
    var body: some View {
        VStack {
            DosageMedicationIcon()
                .scaledToFit()
                .frame(maxWidth: 300, maxHeight: 300)
//                .rotationEffect(.degrees(90))
//                .scaleEffect(2)
            
            VStack(spacing: 30) {
                VStack {
                    Text("Add Dosage")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    GroupBox {
                        TextField("Dosage", text: $dosage)
                            .keyboardType(.numbersAndPunctuation)
                    }
                }
                VStack {
                    Text("Choose Unit")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    GroupBox {
                        VStack {
                            ForEach(CreateMedicationDosageUnit.allCases, id: \.self) { unit in
                                Button {
                                    withAnimation {
                                        self.unit = unit
                                    }
                                } label: {
                                    HStack {
                                        Text(unit.rawValue)
                                        
                                        Spacer()
                                        
                                        if self.unit == unit {
                                            Image(systemName: "checkmark")
                                                .foregroundStyle(.tint)
                                        }
                                    }
                                    .foregroundStyle(Color.primary)
                                }
                                if unit != CreateMedicationDosageUnit.allCases.last {
                                    Divider()
                                }
                            }
                        }
                    }
                }
                
                Button {
                    dismissSheet()
                } label: {
                    Text("Done")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .toolbar(content: {
            Button("Cancel") {
                dismissSheet()
            }
        })
        .navigationTitle(medication.name)
        .onChange(of: dosage) { _, newValue in
            self.medication.dosage = newValue + unit.rawValue
        }
        .onChange(of: unit) { _, newValue in
            self.medication.dosage = dosage + newValue.rawValue
        }
        .padding()
    }
}

#Preview {
    @Previewable @State var medication = Medication(name: "", dosage: "", notes: "")
    
    NavigationStack {
        CreateMedicationView(medication: medication)
    }
}
