//
//  MapDemo.swift
//  SwiftUI-Maps
//
//  Created by codeAlligator on 13/12/25.
//

import SwiftUI

struct MapDemo: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let destination: AnyView
}

extension MapDemo {
    static var all: [MapDemo] = [
        MapDemo(
            title: "Friends Map",
            subtitle: "User location, friends list and detail card",
            destination: AnyView(MapView())
        )
        // later: more demos here
    ]
}
