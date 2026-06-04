//
//  HomeView.swift
//  SwiftUI-Maps
//
//  Created by codeAlligator on 13/12/25.
//

import SwiftUI

struct MapDemo: View {
    let demos = DemoModel.all

    var body: some View {
        NavigationView {
            List {
                ThemePickerView()
                    .listRowInsets(EdgeInsets())

                Section {
                    ForEach(demos) { demo in
                        NavigationLink {
                            demo.destination
                                .navigationBarBackButtonHidden(false)
                                .toolbar {
                                    ToolbarItem(placement: .principal) {
                                        Text(demo.title.uppercased())
                                            .font(.system(size: 14, design: .monospaced))
                                            .foregroundColor(.primary)
                                    }
                                }
                                .navigationBarTitleDisplayMode(.inline)

                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(demo.title.uppercased())
                                    .font(.system(.headline, design: .monospaced))
                                    .fontWeight(.bold)

                                Text(demo.subtitle)
                                    .font(.system(.caption, design: .monospaced))
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                } header: {
                    Text("SwiftUI Mapkit Experiments".uppercased())
                        .font(.system(.footnote, design: .monospaced))
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}
