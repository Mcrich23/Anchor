//
//  MedicationView.swift
//  Anchor
//
//  Created by Morris Richman on 2/2/25.
//

import SwiftUI
import SwiftData

// Exists to Refresh Data when SwiftData is updated by subviews
struct MedicationLogsView: View {
    let isShowingCloseButton: Bool
    @State private var contextDidSaveDate = Date()
    @State var isShowingAddMedicationLogView: MedicationLog? = nil
    @State var isShowingMedManager = false
    
    init(isShowingCloseButton: Bool = true) {
        self.isShowingCloseButton = isShowingCloseButton
    }
    
    var body: some View {
        MedicationLogsViewInternal(isShowingAddMedicationLogView: $isShowingAddMedicationLogView, isShowingMedManager: $isShowingMedManager, isShowingCloseButton: isShowingCloseButton)
            .id(contextDidSaveDate)
            .onReceive(NotificationCenter.default.managedObjectContextDidSavePublisher) { _ in
                guard !isShowingMedManager && isShowingAddMedicationLogView == nil else { return }
                
                contextDidSaveDate = .now
            }
    }
}

// Actual View
private struct MedicationLogsViewInternal: View {
    @Query(filter: #Predicate<MedicationLog> { !$0.medications.isEmpty || $0.notes != nil }, sort: \.date, order: .reverse) var medicationLogs: [MedicationLog] = []
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @Binding var isShowingAddMedicationLogView: MedicationLog?
    @Binding var isShowingMedManager: Bool
    let isShowingCloseButton: Bool
    @EnvironmentObject var userResponseController: UserResponseController
    
    var body: some View {
        List {
            ForEach(medicationLogs) { log in
                Section {
                    Button {
                        isShowingAddMedicationLogView = log
                    } label: {
                        LogEntryView(entry: log)
                    }
                    .buttonStyle(.reactive)
                    .foregroundStyle(.primary, .secondary, .tertiary)
                }
            }
            .onDelete { indexSet in
                userResponseController.playSoundEffect(.delete)
                for index in indexSet {
                    let log = medicationLogs[index]
                    modelContext.delete(log)
                }
                
                try? modelContext.save()
            }
        }
        .animation(.default, value: medicationLogs)
        .navigationTitle("Medication Log")
        .navigationBarTitleDisplayMode(.large)
        .toolbarTitleDisplayMode(.large)
        .overlay(content: {
            if medicationLogs.isEmpty {
                VStack {
                    ContentUnavailableView {
                        Text("No Entries")
                    } description: {
                        Text("You haven't added any entries yet.")
                    } actions: {
                        Button("Get Started") {
                            let medicationLog = MedicationLog.blank
                            self.isShowingAddMedicationLogView = medicationLog
                        }
                        .buttonBorderShape(.roundedRectangle)
                        .buttonStyle(.reactiveBorderedProminent)
                    }
                }
            }
        })
        .toolbar {
            ToolbarItemGroup(placement: .topBarLeading) {
                EditButton()
                    .buttonStyle(.reactive)
                Button {
                    isShowingMedManager = true
                } label: {
                    Label("Manage Medications", systemImage: "gear")
                        .labelStyle(.iconOnly)
                }
                .buttonStyle(.reactive)
                .keyboardShortcut(.init(","), modifiers: .command)
            }
            
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    // Show medication log if one for this minute exists
                    if let medicationLog = medicationLogs.first(where: { $0.date.startOfMinute() == Date().startOfMinute() }),
                       medicationLog.date.startOfMinute() != nil {
                        self.isShowingAddMedicationLogView = medicationLog
                        return
                    }
                    
                    // Show blank log if one does not
                    let medicationLog = MedicationLog.blank
                    self.isShowingAddMedicationLogView = medicationLog
                } label: {
                    Label("Create Entry", systemImage: "plus.circle")
                }
                .buttonStyle(.reactive)
                .keyboardShortcut(.init("n"), modifiers: .command)
                
                if isShowingCloseButton {
                    Button {
                        dismiss()
                    } label: {
                        Label("Close", systemImage: "xmark.circle")
                    }
                    .buttonStyle(.secondaryReactive)
                    .keyboardShortcut(.escape, modifiers: .command)
                }
            }
        }
        .sheet(isPresented: $isShowingMedManager, content: {
            NavigationStack {
                MedicationManagementView()
            }
        })
        .sheet(item: $isShowingAddMedicationLogView) { item in
            NavigationStack {
                AddMedicationLogView(medicationLog: item, in: modelContext)
                    .environment(\.customDismiss, {})
            }
        }
    }
}

private struct LogEntryView: View {
    let entry: MedicationLog
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(entry.date.formatted(date: .abbreviated, time: .shortened))
                .font(.headline)
                .fontDesign(.default)
            Divider()
            ForEach(entry.takenMedications) { medication in
                EntryLogMedicationView(medication: medication)
            }
            
            if let notes = entry.notes {
                if entry.takenMedications.isEmpty {
                    Text(notes)
                        .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    GroupBox {
                        Text(notes)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }
    }
}

private struct EntryLogMedicationView: View {
    let medication: MedicationLogMed
    
    var body: some View {
        HStack {
            Image(systemName: "pill.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
                .symbolRenderingMode(.multicolor)
                .foregroundStyle(.pink)
            Text(medication.underlyingMedication?.name ?? medication.name)
            
            Text("\(medication.quantity) (\(medication.dosage))")
                .padding(.vertical, 3)
                .padding(.horizontal)
                .background(Color.dynamicColor(light: .secondarySystemBackground, dark: .tertiarySystemBackground), in: RoundedRectangle(cornerRadius: 6))
        }
    }
}

extension Date {
    func startOfMinute(from calendar: Calendar = .current) -> Self? {
        calendar.date(bySetting: .second, value: 0, of: self)
    }
}

#Preview {
    NavigationStack {
        MedicationLogsView()
    }
        .modelContainer(for: MedicationLog.self, isAutosaveEnabled: true)
}
