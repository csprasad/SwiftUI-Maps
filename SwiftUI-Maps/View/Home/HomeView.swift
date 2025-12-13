//
//  HomeView.swift
//  SwiftUI-Maps
//
//  Created by codeAlligator on 13/12/25.
//

import SwiftUI

struct HomeView: View {
    let demos = MapDemo.all

    var body: some View {
        NavigationView {
            List {
                ThemePickerView()
//                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets())
                
                Section("SwiftUI Map Experiments") {
                    ForEach(demos) { demo in
                        NavigationLink {
                            demo.destination
                                .navigationTitle(demo.title)
                                .navigationBarTitleDisplayMode(.inline)
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(demo.title)
                                    .font(.headline)
                                Text(demo.subtitle)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
        }
    }
}

