//
//  SwiftUI_MapsApp.swift
//  SwiftUI-Maps
//
//  Created by codeAlligator on 10/12/25.
//

import SwiftUI

@main
struct SwiftUI_MapsApp: App {
    @StateObject private var themeManager = ThemeManager()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(themeManager)
                .preferredColorScheme(themeManager.selectedTheme.colorScheme)
        }
    }
}
