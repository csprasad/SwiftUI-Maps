//
//
//  TacticalMasterCard.swift
//  SwiftUI-Maps
//
/// Created by `C S Prasad` on `01/06/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
import CoreLocation

struct TacticalMasterCard: View {
    @Binding var nodes: [TacticalNode]
    @Binding var selectedNodeID: UUID?
    @Binding var isExpanded: Bool
    var clockTrigger: Bool // Binding free refresh trigger
    
    // Global Territory Anchor (First Node Added Context)
    private var anchorNode: TacticalNode? {
        nodes.first
    }
    
    // Calculates cumulative path distance (Node 1 -> Node 2 -> Node 3...)
    private var totalRoutePathDistance: String {
        guard nodes.count > 1 else { return "0.00 m" }
        var totalMeters: Double = 0.0
        
        for i in 0..<(nodes.count - 1) {
            let locA = CLLocation(latitude: nodes[i].coordinate.latitude, longitude: nodes[i].coordinate.longitude)
            let locB = CLLocation(latitude: nodes[i+1].coordinate.latitude, longitude: nodes[i+1].coordinate.longitude)
            totalMeters += locA.distance(from: locB)
        }
        return totalMeters >= 1000 ? String(format: "%.2f km", totalMeters / 1000.0) : String(format: "%.0f m", totalMeters)
    }
    
    // Surface Area calculation
    private var calculatedArea: String {
        guard nodes.count >= 3 else { return "0.00 m²" }
        let kEarthRadius = 6378137.0
        var totalArea = 0.0
        let coords = nodes.map { $0.coordinate }
        
        for i in 0..<coords.count {
            let p1 = coords[i > 0 ? i - 1 : coords.count - 1]
            let p2 = coords[i]
            totalArea += ((p2.longitude - p1.longitude) * .pi / 180.0) * (2.0 + sin(p1.latitude * .pi / 180.0) + sin(p2.latitude * .pi / 180.0))
        }
        totalArea = abs(totalArea * kEarthRadius * kEarthRadius / 2.0)
        return totalArea >= 1_000_000 ? String(format: "%.2f km²", totalArea / 1_000_000.0) : String(format: "%.0f m²", totalArea)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Anchor Details & Clock Tracker Subview Group
            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("TACTICAL OPERATIONS COMPLEX")
                            .font(.system(size: 9, weight: .black, design: .monospaced))
                            .foregroundColor(.cyan)
                        
                        // Dynamic Anchor Readout
                        if let anchor = anchorNode {
                            Text("\(anchor.landmark), \(anchor.cityName), \(anchor.countryCode)")
                                .font(.headline).fontWeight(.bold).foregroundColor(.primary).lineLimit(1)
                            
                            Text("ANCHOR CLOCK: \(anchor.currentLocalTime) \(anchor.timeZoneAbbreviation)")
                                .font(.system(size: 10, design: .monospaced))
                                .foregroundColor(.cyan.opacity(0.85))
                                .id(clockTrigger) // Forces structural redraw every second
                        } else {
                            Text("GRID OFFLINE: INITIALIZE MARKS")
                                .font(.headline).fontWeight(.bold).foregroundColor(.primary.opacity(0.4))
                        }
                    }
                    Spacer()
                    
                    if !nodes.isEmpty {
                        Button(action: { withAnimation(.spring(response: 0.35)) { isExpanded.toggle() } }) {
                            Image(systemName: isExpanded ? "chevron.down.circle.fill" : "chevron.up.circle.fill")
                                .font(.title3).foregroundColor(.cyan)
                        }
                    }
                }
                
                Divider().background(Color.primary.opacity(0.12)).padding(.vertical, 2)
                
                // Double Metric Status Layout
                HStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("POLYGON MESH BOUNDS")
                            .font(.system(size: 8, weight: .bold, design: .monospaced)).foregroundColor(.secondary)
                        Text(calculatedArea)
                            .font(.system(size: 15, weight: .bold, design: .monospaced)).foregroundColor(.green)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("TOTAL ROUTING TRAIL RUN")
                            .font(.system(size: 8, weight: .bold, design: .monospaced)).foregroundColor(.secondary)
                        Text(totalRoutePathDistance)
                            .font(.system(size: 15, weight: .bold, design: .monospaced)).foregroundColor(.orange)
                    }
                }
            }
            .padding(16)
            
            // Expanded Core Logs View list
            if isExpanded && !nodes.isEmpty {
                Divider().background(Color.primary.opacity(0.15))
                
                ScrollView {
                    VStack(spacing: 6) {
                        ForEach(Array(nodes.enumerated()), id: \.element.id) { idx, node in
                            HStack {
                                Text(String(format: "V%02d", idx + 1))
                                    .font(.system(size: 10, weight: .black, design: .monospaced)).foregroundColor(.cyan)
                                Text(node.landmark)
                                    .font(.caption2).bold().foregroundColor(.primary).lineLimit(1)
                                Spacer()
                                Image(systemName: "scope")
                                    .font(.caption2)
                                    .foregroundColor(selectedNodeID == node.id ? .purple : .secondary)
                            }
                            .padding(8)
                            .background(selectedNodeID == node.id ? Color.cyan.opacity(0.12) : Color.primary.opacity(0.03))
                            .cornerRadius(6)
                            .onTapGesture { selectedNodeID = node.id }
                        }
                    }
                    .padding(10)
                }
                .frame(maxHeight: 130)
            }
        }
        .padding(.bottom, 4)
        .glassEffect(
            .regular,
            in: .rect(cornerRadius: 22)
        )
    }
}
