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
    
    var velocity: CGPoint {
        switch self {
        case .rain: return CGPoint(x: 0.5, y: 10)
        case .wind: return CGPoint(x: 12, y: 0.4)
        case .snow: return CGPoint(x: -0.8, y: 2)
        }
    }
    
    var color: Color {
        switch self {
        case .rain: return .cyan
        case .wind: return .white
        case .snow: return .white
        }
    }
    
    var particleStretch: CGFloat {
        switch self {
        case .rain: return 10
        case .wind: return 10
        case .snow: return 1
        }
    }
    
    var particleCount: Int {
        switch self {
        case .rain: return 180
        case .wind: return 150
        case .snow: return 140
        }
    }
}
