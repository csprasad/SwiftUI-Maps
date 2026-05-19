//
//  ThemePickerView.swift
//  SwiftUI-Maps
//
//  Created by codeAlligator on 14/12/25.
//

import SwiftUI

struct ThemePickerView: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        HStack {
            Label {
                Text("MapEx")
            } icon: {
                Image(systemName: "map")
                    .foregroundColor(.green)
            }
            .font(.headline)
                
            Spacer()
            
            Picker("Theme", selection: $themeManager.selectedTheme) {
                ForEach(AppTheme.allCases) { theme in
                    Text(theme.rawValue).tag(theme)
                }
            }
            .pickerStyle(.segmented)
            .frame(width: 220)
        }
        .padding(10)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

