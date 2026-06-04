//
//  SwiftUI_MapsApp.swift
//  SwiftUI-Maps
//
//  Created by codeAlligator on 10/12/25.
//

import SwiftUI

@main
struct MapExApp: App {
    @StateObject private var themeManager = ThemeManager()

    var body: some Scene {
        WindowGroup {
            MapDemo()
                .environmentObject(themeManager)
                .preferredColorScheme(themeManager.selectedTheme.colorScheme)
        }
    }
}
