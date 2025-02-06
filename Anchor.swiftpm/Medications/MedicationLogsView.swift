//
//  MedicationView.swift
//  Anchor
//
//  Created by Morris Richman on 2/2/25.
//

import SwiftUI
import SwiftData

struct MedicationLogsView: View {
    @Query(filter: #Predicate<MedicationLog> { !$0.medications.isEmpty }) var medicationLogs: [MedicationLog] = []
    @Environment(\.modelContext) var modelContext
    @State var isShowingAddMedicationLogView: Bool = false
    
    var body: some View {
        List {
            ForEach(medicationLogs) { log in
                Section {
                    VStack(alignment: .leading) {
                        Text(log.date.formatted(date: .abbreviated, time: .standard))
                            .font(.headline)
                            .fontDesign(.default)
                        Divider()
                        ForEach(log.medications) { medication in
                            HStack {
                                Image(systemName: "pill.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 25, height: 25)
                                    .symbolRenderingMode(.multicolor)
                                    .foregroundStyle(.pink)
                                Text("\(medication.name)")
                                
                                Text("\(log.medicationQuantities?[medication.persistentModelID] ?? 1)")
                                    .padding(.vertical, 3)
                                    .padding(.horizontal)
                                    .background(Color.dynamicColor(light: .tertiarySystemBackground, dark: .tertiarySystemBackground), in: RoundedRectangle(cornerRadius: 6))
                            }
                        }
                    }
                }
            }
            .onDelete { indexSet in
                for index in indexSet {
                    let log = medicationLogs[index]
                    modelContext.delete(log)
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .topBarLeading) {
                EditButton()
            }
            
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    isShowingAddMedicationLogView.toggle()
                } label: {
                    Label("Create Entry", systemImage: "plus.circle")
                }
            }
        }
        .sheet(isPresented: $isShowingAddMedicationLogView) {
            NavigationStack {
                AddMedicationLogView()
            }
        }
    }
}

#Preview {
    NavigationStack {
        MedicationLogsView()
    }
        .modelContainer(for: MedicationLog.self, isAutosaveEnabled: true)
}
