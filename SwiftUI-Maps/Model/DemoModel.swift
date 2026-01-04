//
//  MapDemo.swift
//  SwiftUI-Maps
//
//  Created by codeAlligator on 13/12/25.
//

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
            title: "Friends Map",
            subtitle: "User location, friends list and detail card",
            destination: AnyView(FriendsMapView())
        ),
        DemoModel(
            title: "Search Places",
            subtitle: "User location, search bar and mark Places",
            destination: AnyView(MapSearchView())
        )
        // later: more demos here
    ]
}
