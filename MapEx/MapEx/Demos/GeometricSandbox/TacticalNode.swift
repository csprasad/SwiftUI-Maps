//
//
//  TacticalNode.swift
//  SwiftUI-Maps
//
/// Created by `C S Prasad` on `01/06/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import Foundation
import CoreLocation

// MARK: - Tactical Model Core
struct TacticalNode: Identifiable, Equatable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
    var cityName: String = "Scanning Grid..."
    var landmark: String = "Locating Sector Asset..."
    var zone: String = "Sector"
    var countryCode: String = ""
    var timeZone: TimeZone?

    // Calculated readable formatting helper for local coordinate clock time
    var currentLocalTime: String {
        guard let tz = timeZone else { return "--:--:--" }
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.timeZone = tz
        return formatter.string(from: Date())
    }

    var timeZoneAbbreviation: String {
        return timeZone?.abbreviation() ?? "UTC"
    }

    static func == (lhs: TacticalNode, rhs: TacticalNode) -> Bool { lhs.id == rhs.id }
}

// MARK: - Orbital Tactical Processor Engine
struct TacticalTelemetry {
    let currentNode: TacticalNode

    // Loop Sequences (Orbital Closed Loop Math)
    var previousNode: TacticalNode
    var distanceToPrevious: Double

    var nextNode: TacticalNode
    var distanceToNext: Double

    // Absolute Geographic Proximity
    var nearestNode: TacticalNode?
    var distanceToNearest: Double?

    init?(for node: TacticalNode, in nodes: [TacticalNode]) {
        guard !nodes.isEmpty, let currentIndex = nodes.firstIndex(where: { $0.id == node.id }) else { return nil }
        self.currentNode = node

        let currentLoc = CLLocation(latitude: node.coordinate.latitude, longitude: node.coordinate.longitude)
        let totalCount = nodes.count

        // PREVIOUS NODE CLOSED LOOP LOGIC
        let prevIndex = (currentIndex - 1 + totalCount) % totalCount
        let prevTarget = nodes[prevIndex]
        self.previousNode = prevTarget
        let prevLoc = CLLocation(latitude: prevTarget.coordinate.latitude, longitude: prevTarget.coordinate.longitude)
        // If there's only 1 node, distance will naturally calculate as 0
        self.distanceToPrevious = currentLoc.distance(from: prevLoc)

        // NEXT NODE CLOSED-LOOP LOGIC
        let nextIndex = (currentIndex + 1) % totalCount
        let nextTarget = nodes[nextIndex]
        self.nextNode = nextTarget
        let nextLoc = CLLocation(latitude: nextTarget.coordinate.latitude, longitude: nextTarget.coordinate.longitude)
        self.distanceToNext = currentLoc.distance(from: nextLoc)

        // ABSOLUTE GEOGRAPHIC NEAREST NODE PROXIMITY
        var closestNode: TacticalNode?
        var shortestDistance: CLLocationDistance = .infinity

        for checkNode in nodes where checkNode.id != node.id {
            let checkLoc = CLLocation(latitude: checkNode.coordinate.latitude, longitude: checkNode.coordinate.longitude)
            let dist = currentLoc.distance(from: checkLoc)
            if dist < shortestDistance {
                shortestDistance = dist
                closestNode = checkNode
            }
        }

        if let closest = closestNode {
            self.nearestNode = closest
            self.distanceToNearest = shortestDistance
        }
    }
}
