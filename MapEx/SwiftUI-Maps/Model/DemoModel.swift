//
//  MapDemo.swift
//  SwiftUI-Maps
//
///  Created by `C S Prasad` on `13/12/25`
///
///`iOS • SwiftUI • Creative Coding`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios``
/// `X`                   : ``@csprasad_ios``
/// `Github`        : ``@csprasad``
///


import SwiftUI

struct DemoModel: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let destination: AnyView
}

extension DemoModel {
    static var all: [DemoModel] = [
        DemoModel(
            title: "Friends Radar",
            subtitle: "Active positions, status mapping, and profiles cards",
            destination: AnyView(FriendsMapView())
        ),
        DemoModel(
            title: "Tactical Nav Simulation",
            subtitle: "A dark mode tactical map simulation with live ETA tracking.",
            destination: AnyView(TacticalNavView())
        ),
        DemoModel(
            title: "Tactical Command Deck",
            subtitle: "Real-time geographic telemetry processing.",
            destination: AnyView(GeometricSandboxView())
        ),
        DemoModel(
            title: "Weather Simulation",
            subtitle: "Real-time weather particle engine with procedural physics.",
            destination: AnyView(WeatherSimulationView())
        ),
        DemoModel(
            title: "Search Places",
            subtitle: "User location, search bar and markere",
            destination: AnyView(MapSearchView())
        ),
    ]
}
