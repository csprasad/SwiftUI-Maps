//
//
//  TacticalInterceptCard.swift
//  SwiftUI-Maps
//
/// Created by `C S Prasad` on `01/06/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
import MapKit

struct TacticalInterceptCard: View {
    @Binding var nodes: [TacticalNode]
    @Binding var selectedNodeID: UUID?
    @Binding var isExpanded: Bool
    var clockTrigger: Bool
    
    private var telemetry: TacticalTelemetry? {
        guard let id = selectedNodeID, let node = nodes.first(where: { $0.id == id }) else { return nil }
        return TacticalTelemetry(for: node, in: nodes)
    }
    
    var body: some View {
        guard let tel = telemetry else { return AnyView(EmptyView()) }
        
        return AnyView(
            VStack(spacing: 0) {
                // Main Header Group
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("TARGET COORDINATE MATRIX")
                                .font(.system(size: 9, weight: .black, design: .monospaced)).foregroundColor(.purple)
                            Text(tel.currentNode.landmark)
                                .font(.subheadline).bold().foregroundColor(.primary).lineLimit(1)
                            Text("LOCAL TIME: \(tel.currentNode.currentLocalTime) \(tel.currentNode.timeZoneAbbreviation)")
                                .font(.system(size: 10, design: .monospaced)).foregroundColor(.purple.opacity(0.85))
                                .id(clockTrigger)
                        }
                        Spacer()
                        
                        HStack(spacing: 12) {
                            Button(action: { withAnimation(.spring()) { isExpanded.toggle() } }) {
                                Image(systemName: isExpanded ? "arrow.down.right.and.arrow.up.left.circle.fill" : "arrow.up.left.and.arrow.down.right.circle.fill")
                                    .foregroundColor(.purple).font(.title3)
                            }
                            Button(action: { withAnimation { nodes.removeAll(where: { $0.id == tel.currentNode.id }); selectedNodeID = nil } }) {
                                Image(systemName: "minus.circle.fill").foregroundColor(.red).font(.title3)
                            }
                        }
                    }
                    
                    // Always Visible Root Coordinates Vector
                    Text(String(format: "TARGET CORE LAT: %.6f / LON: %.6f", tel.currentNode.coordinate.latitude, tel.currentNode.coordinate.longitude))
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundColor(.primary.opacity(0.6))
                        .padding(.top, 2)
                }
                .padding(14)
                
                // Expanded Vector Arrays
                if isExpanded {
                    Divider().background(Color.primary.opacity(0.15))
                    
                    ScrollView {
                        VStack(spacing: 8) {
                            // Loop Orbital Link i-1
                            TelemetryRow(
                                title: "CLOSED LOOP ORBITAL PREVIOUS (i-1)",
                                landmark: tel.previousNode.landmark,
                                lat: tel.previousNode.coordinate.latitude,
                                lon: tel.previousNode.coordinate.longitude,
                                distance: tel.distanceToPrevious
                            )
                            
                            Divider()
                            
                            // Loop Orbital Link i+1
                            TelemetryRow(
                                title: "CLOSED LOOP ORBITAL NEXT (i+1)",
                                landmark: tel.nextNode.landmark,
                                lat: tel.nextNode.coordinate.latitude,
                                lon: tel.nextNode.coordinate.longitude,
                                distance: tel.distanceToNext
                            )
                            
                            Divider().background(Color.primary.opacity(0.12)).padding(.vertical, 2)
                            
                            // Proximity Closest Geographic Sweep Vector
                            if let nearest = tel.nearestNode, let nearestDist = tel.distanceToNearest {
                                TelemetryRow(
                                    title: "CRITICAL PROXIMITY GEOGRAPHIC NEAREST",
                                    landmark: nearest.landmark,
                                    lat: nearest.coordinate.latitude,
                                    lon: nearest.coordinate.longitude,
                                    distance: nearestDist,
                                    highlighted: true
                                )
                            }
                        }
                        .padding(12)
                    }
                    .frame(maxHeight: 210)
                }
            }
            .glassEffect(
                .regular,
                in: .rect(cornerRadius: 22)
            )
        )
    }
}

// MARK: - Reusable Telemetry Element Row View
struct TelemetryRow: View {
    let title: String
    let landmark: String
    let lat: Double
    let lon: Double
    let distance: Double
    var highlighted: Bool = false
    
    private var formattedRangeDistance: String {
        if distance == 0.0 { return "0.00 m (SELF)" }
        return distance >= 1000 ? String(format: "%.2f km", distance / 1000.0) : String(format: "%.0f m", distance)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                VStack(alignment: .leading, spacing: 1) {
                    Text(title)
                        .font(.system(size: 8, weight: .black, design: .monospaced))
                        .foregroundColor(highlighted ? .orange : .secondary)
                    Text(landmark)
                        .font(.caption).bold().foregroundColor(.primary).lineLimit(1)
                }
                Spacer()
                
                Text(formattedRangeDistance)
                    .font(.system(size: 11, weight: .black, design: .monospaced))
                    .foregroundColor(highlighted ? .orange : .cyan)
            }
            
            Text(String(format: "VECTOR POS -> LAT: %.5f / LON: %.5f", lat, lon))
                .font(.system(size: 9, design: .monospaced))
                .foregroundColor(.primary.opacity(0.45))
        }
    }
}
