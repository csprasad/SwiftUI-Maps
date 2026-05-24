//
//
//  WeatherModel.swift
//  SwiftUI-Maps
//
/// Created by `C S Prasad` on `25/05/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - Particle Model
struct WeatherModel: Identifiable {
    let id = UUID()
    var position: CGPoint
    var speed: CGFloat
    var opacity: Double
    var size: CGFloat
    var phase: CGFloat
}
