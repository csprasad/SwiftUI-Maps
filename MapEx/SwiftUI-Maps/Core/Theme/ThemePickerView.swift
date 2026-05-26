//
//  ThemePickerView.swift
//  SwiftUI-Maps
//
//  Created by codeAlligator on 14/12/25.
//

import SwiftUI

struct ThemePickerView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.colorScheme) var currentColorScheme
    
    private var isDark: Bool {
        if themeManager.selectedTheme == .system {
            return currentColorScheme == .dark
        }
        return themeManager.selectedTheme == .dark
    }
    
    var body: some View {
        HStack {
            Label {
                Text("MapEx")
                    .tracking(0.5)
            } icon: {
                Image(systemName: "map.fill")
                    .symbolEffect(.bounce, value: themeManager.selectedTheme)
                    .foregroundColor(.green)
            }
            .font(.system(.headline, design: .monospaced))
            
            Spacer()
            
            Button {
                withAnimation(.spring(response: 0.25, dampingFraction: 0.75)) {
                    themeManager.selectedTheme = isDark ? .light : .dark
                }
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: isDark ? "moon.stars.fill" : "sun.max.fill")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(isDark ? .white : .yellow)
                        .contentTransition(.symbolEffect(.replace))
                }
                .frame(width: 30, height: 30)
                .background(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(.green.opacity(0.1))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(.green.opacity(0.2), lineWidth: 1)
                )
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}
