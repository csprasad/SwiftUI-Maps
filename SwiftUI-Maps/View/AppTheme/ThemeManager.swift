//
//  ThemeManager.swift
//  SwiftUI-Maps
//
//  Created by codeAlligator on 14/12/25.
//

import SwiftUI
internal import Combine

final class ThemeManager: ObservableObject {
    @Published var selectedTheme: AppTheme = .system
}
