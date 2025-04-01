//
//  SourcesView.swift
//  Anchor
//
//  Created by Morris Richman on 4/1/25.
//

import SwiftUI

struct SourcesView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Icon")) {
                    Link("Anchor Icon", destination: URL(string: "https://www.flaticon.com/free-icon/anchor_4287284")!)
                    Link("Generated with the Bakery App", destination: URL(string: "https://apps.apple.com/us/app/bakery-simple-icon-creator/id1575220747?mt=12")!)
                }
                .textCase(nil)
                
                Section(header: Text("Color Science")) {
                    Link("Migraine Light Therapy", destination: URL(string: "https://www.verywellhealth.com/migraine-light-therapy-4114138")!)
                    Link("Color Your World to Relieve Stress", destination: URL(string: "https://www.moffitt.org/endeavor/archive/color-your-world-to-relieve-stress")!)
                }
                .textCase(nil)
                
                Section(header: Text("Migraines")) {
                    Link("Mayo Clinic - Migraines", destination: URL(string: "https://www.mayoclinic.org/diseases-conditions/migraine-headache/in-depth/migraines/art-20047242")!)
                    Link("NHS - Migraines", destination: URL(string: "https://www.nhs.uk/conditions/migraine/")!)
                    Link("Migraine Light Therapy", destination: URL(string: "https://www.verywellhealth.com/migraine-light-therapy-4114138")!)
                }
                .textCase(nil)
                
                Section(header: Text("Panic Attacks")) {
                    Link("Medical News Today", destination: URL(string: "https://www.medicalnewstoday.com/articles/321510#methods")!)
                    Link("Conversation with Dr. Matthew Hopperstad MD", destination: URL(string: "https://www.hopperstadmd.com")!)
                    Link("Dropping Anchor Script", destination: URL(string: "https://www.actmindfully.com.au/upimages/Dropping_anchor_script.pdf")!)
                    Link("Flourish Mindfully Blog", destination: URL(string: "https://www.flourishmindfully.com.au/blog/dropping-anchor")!)
                }
                .textCase(nil)
                
                Section {
                    Link("Tranquility by David Renda", destination: URL(string: "https://www.fesliyanstudios.com/royalty-free-music/download/tranquility/331")!)
                } header: {
                    VStack(alignment: .leading) {
                        Text("Audio")
                            .font(.headline)
                        HStack {
                            Text("Fesliyan Studios")
                            Spacer()
                            Link("Usage Policy", destination: URL(string: "https://www.fesliyanstudios.com/policy")!)
                                .buttonStyle(.reactiveBordered)
                        }
                    }
                }
                .textCase(nil)
                
                Section {
                    Link("Level Passed by Universfield", destination: URL(string: "https://pixabay.com/sound-effects/level-passed-142971/")!)
                    Link("Click Button App by Universfield", destination: URL(string: "https://pixabay.com/sound-effects/click-button-app-147358/")!)
                    Link("Modern Button Click by freesoundeffects", destination: URL(string: "https://pixabay.com/sound-effects/modern-button-click-291234/")!)
                } header: {
                    HStack {
                        Text("Pixabay")
                        Spacer()
                        Link("License", destination: URL(string: "https://pixabay.com/service/license-summary/")!)
                            .buttonStyle(.reactiveBordered)
                    }
                }
                .textCase(nil)
            }
            .buttonStyle(.reactive)
            .navigationTitle("Sources")
            .toolbar {
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
}

#Preview {
    SourcesView()
}
