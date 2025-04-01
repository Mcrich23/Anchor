//
//  MTakeActionView.swift
//  Anchor
//
//  Created by Morris Richman on 1/16/25.
//

import Foundation
import SwiftUI
import SwiftData

struct MTakeActionView: View {
    let shareText: String = "Hello, I am experiencing a migraine. I am using the app Anchor to help me manage my symptoms. If you don't hear back from me in the next 30 minutes, please call me."
    @Environment(\.geometrySize) var geo
    @Environment(\.meshCircleSize) var meshCircleSize
    @EnvironmentObject var meshBackgroundCircleViewModel: AnimatedMeshViewModel
    @State var isShowingAddMedicationLogEntry: MedicationLog? = .blank
    @State var isShowingMedicationLog = false
    @FocusState var isEditingMedicationLog
    @Environment(\.modelContext) var modelContext
    @Environment(\.orientation) var orientation
    @Environment(\.nonFlatOrientation) var nonFlatOrientation
    @Environment(\.userInterfaceIdiom) var userInterfaceIdiom
    @Environment(\.isShowingNavigationButtons) var isShowingNavigationButtons
    @Environment(\.isShowingNavigationBar) var isShowingNavigationBar
    @Query(filter: #Predicate<MedicationLog> { !$0.medications.isEmpty || $0.notes != nil }, sort: \.date, order: .reverse) var medicationLogs: [MedicationLog] = []
    
    var gradientColors: [Color] {
        .semiCircleGradientColorsInAnchor
    }
    
    @ViewBuilder
    var meshGradientBackground: some View {
        SemiCircle(colors: gradientColors, animatedMeshViewModel: meshBackgroundCircleViewModel)
            .foregroundStyle(Gradient(colors: gradientColors))
            .frame(minWidth: 600, idealWidth: meshCircleSize.width)
            .frame(height: meshCircleSize.height/1.8)
            .ignoresSafeArea()
            .scaleEffect(x: 3)
            .scaleEffect(y:  3.4)
            .position(x: meshCircleSize.width/2, y: meshCircleSize.height/2)
    }
    
    var body: some View {
        VStack {
            Group {
                Text("Take Medication")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                Text("Taking medication can be integral to managing migraines. If you have specific medication, or general pain medication, make sure to take it as directed.")
                    .minimumScaleFactor(0.7)
            }
            NavigationStack {
                Group {
                    if let isShowingAddMedicationLogEntry {
                        AddMedicationLogView(showManageMedicationButton: true, showAddMedicationButton: false, isEditingMedicationLog: _isEditingMedicationLog, medicationLog: isShowingAddMedicationLogEntry, in: modelContext)
                            .environment(\.customDismiss, { self.isShowingAddMedicationLogEntry = nil })
                    } else {
                        MedicationLogsView(isShowingCloseButton: false)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .scrollContentBackground(.hidden)
                .background(.ultraThinMaterial)
                .background {
                    meshGradientBackground
                }
                .toolbarBackground(.thinMaterial, for: .navigationBar)
            }
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .animation(.default, value: isShowingAddMedicationLogEntry)
                .presentationBackground(.red)
        }
        .onAppear(perform: {
            // Show medication log if one for this minute exists
            if let medicationLog = medicationLogs.first(where: { $0.date.startOfMinute() == Date().startOfMinute() }),
               medicationLog.date.startOfMinute() != nil {
                self.isShowingAddMedicationLogEntry = medicationLog
            }
        })
        .onChange(of: isEditingMedicationLog, initial: true, { _, newValue in
            guard nonFlatOrientation.isLandscape || userInterfaceIdiom == .phone else {
                self.isShowingNavigationButtons.wrappedValue = true
                self.isShowingNavigationBar.wrappedValue = true
                return
            }
            
            withAnimation {
                self.isShowingNavigationButtons.wrappedValue = !newValue
                self.isShowingNavigationBar.wrappedValue = !newValue
            }
        })
        .padding(.horizontal)
    }
    
    @ViewBuilder
    var boxes: some View {
        Group {
            box {
                Text("Take Medication")
                    .font(.title2)
                    .fontWeight(.semibold)
                Text("Taking medication can be integral to managing migraines. If you have specific medication, or general pain medication, make sure to take it as directed.")
                    .minimumScaleFactor(0.7)
                HStack {
                    Button("Take Medication") {
                        isShowingAddMedicationLogEntry = .blank
                    }
                    .buttonStyle(.reactiveBorderedProminent)
                    Button {
                        isShowingMedicationLog = true
                    } label: {
                        Label("Medication Log", systemImage: "calendar.day.timeline.left")
                            .labelStyle(.iconOnly)
                    }
                    .buttonStyle(.reliefNavigation)
                }
            }
        }
        .multilineTextAlignment(.center)
    }
    
    @ViewBuilder
    func box(@ViewBuilder _ view: () -> some View) -> some View {
        VStack(spacing: 20) {
            view()
        }
//        .frame(maxWidth: 800, minHeight: 100, maxHeight: 800)
        .padding()
        .background(Color(uiColor: .secondarySystemFill).opacity(0))
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}
