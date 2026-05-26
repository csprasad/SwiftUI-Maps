//
//
//  WeatherType.swift
//  SwiftUI-Maps
//
/// Created by `C S Prasad` on `25/05/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
internal import Combine


// MARK: - Weather Types
enum WeatherType: String, CaseIterable, Identifiable {
    case rain = "Rain"
    case wind = "Wind"
    case snow = "Snow"
    
    var id: String { rawValue }
    
    var targetVelocity: CGPoint {
        switch self {
        case .rain: return CGPoint(x: 0.2, y: 6.0)
        case .wind: return CGPoint(x: 8.0, y: 0.1)
        case .snow: return CGPoint(x: -0.3, y: 1.5)
        }
    }
    
    var color: Color {
        switch self {
        case .rain: return Color.cyan
        case .wind: return Color.blue.opacity(0.4)
        case .snow: return Color.white
        }
    }
    
    var particleStretch: CGFloat {
        switch self {
        case .rain: return 8.0
        case .wind: return 24.0
        case .snow: return 1.0
        }
    }
    
    var maxParticles: Int {
        switch self {
        case .rain: return 200
        case .wind: return 80
        case .snow: return 120
        }
    }
}
