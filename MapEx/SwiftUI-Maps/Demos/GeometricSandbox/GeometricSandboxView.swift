//
//
//  GeometricSandboxView.swift
//  SwiftUI-Maps
//
/// Created by `C S Prasad` on `01/06/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
import MapKit
internal import Combine

public struct GeometricSandboxView: View {
    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 40.7580, longitude: -73.9855), // Times Square Anchor Default
            span: MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)
        )
    )
    
    @State private var nodes: [TacticalNode] = []
    @State private var selectedNodeID: UUID? = nil
    @State private var isMasterExpanded: Bool = false
    @State private var isInterceptExpanded: Bool = false
    
    // Real-time clock updates across HUD assets
    @State private var telemetryPulseTimer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    @State private var timeRefreshTrigger: Bool = false
    
    public init() {}
    
    public var body: some View {
        ZStack {
            MapReader { proxy in
                Map(position: $position) {
                    // Mesh Polygon Layer
                    if nodes.count >= 3 {
                        MapPolygon(coordinates: nodes.map { $0.coordinate })
                            .stroke(.cyan.opacity(0.85), lineWidth: 2)
                            .foregroundStyle(LinearGradient(colors: [.cyan.opacity(0.18), .purple.opacity(0.04)], startPoint: .top, endPoint: .bottom))
                    }
                    
                    // Vector Radar Annotation Markers
                    ForEach(nodes) { node in
                        Annotation("", coordinate: node.coordinate) {
                            TacticalPinView(node: node, isSelected: selectedNodeID == node.id)
                                .gesture(
                                    DragGesture(minimumDistance: 0, coordinateSpace: .global)
                                        .onChanged { gesture in
                                            selectedNodeID = node.id
                                            
                                            if let newCoordinate = proxy.convert(gesture.location, from: .global) {
                                                updateNodeCoordinate(id: node.id, to: newCoordinate)
                                            }
                                        }
                                        .onEnded { _ in
                                            fetchGeocodingTelemetry(for: node.id)
                                        }
                                )
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                                        selectedNodeID = (selectedNodeID == node.id) ? nil : node.id
                                        selectedNodeID = node.id
                                    }
                                }
                        }
                    }
                }
                .mapStyle(.standard)
                .onTapGesture { screenPoint in
                    if let coordinate = proxy.convert(screenPoint, from: .local) {
                        createNewNode(at: coordinate)
                    }
                }
            }
            
            // Sticky Warning Hub Top Panel
            VStack {
                HStack {
                    Image(systemName: nodes.count >= 3 ? "scope" : "exclamationmark.triangle.fill")
                        .foregroundColor(nodes.count >= 3 ? .cyan : .orange)
                        .font(.system(size: 15, weight: .bold, design: .monospaced))
                    Text(nodes.count >= 3 ? "PERIMETER MESH ACTIVE | SECURE TRACKING SEC-METRICS" : "PERIMETER UNBOUNDED: DEPLOY MINIMUM 3 NODES FOR MESH MAPPING")
                        .font(.system(size: 9, weight: .black, design: .monospaced))
                        .foregroundColor(nodes.count >= 3 ? .cyan : .orange)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .glassEffect(.regular, in: .rect(cornerRadius: 22))
                .cornerRadius(8)
                
                Spacer()
                
                // Dual Card Command Center (Anchored Bottom)
                VStack(spacing: 8) {
                    TacticalMasterCard(
                        nodes: $nodes,
                        selectedNodeID: $selectedNodeID,
                        isExpanded: $isMasterExpanded,
                        clockTrigger: timeRefreshTrigger
                    )
                    
                    if selectedNodeID != nil {
                        TacticalInterceptCard(
                            nodes: $nodes,
                            selectedNodeID: $selectedNodeID,
                            isExpanded: $isInterceptExpanded,
                            clockTrigger: timeRefreshTrigger
                        )
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 12)
            }
        }
        .onReceive(telemetryPulseTimer) { _ in
            timeRefreshTrigger.toggle() // clock updates across custom card modules
        }
    }
    
    private func updateNodeCoordinate(id: UUID, to coordinate: CLLocationCoordinate2D) {
        if let index = nodes.firstIndex(where: { $0.id == id }) {
            nodes[index].coordinate = coordinate
        }
    }
    
    private func createNewNode(at coordinate: CLLocationCoordinate2D) {
        let newNode = TacticalNode(coordinate: coordinate)
        nodes.append(newNode)
        selectedNodeID = newNode.id
        fetchGeocodingTelemetry(for: newNode.id)
    }
    
    private func fetchGeocodingTelemetry(for id: UUID) {
        guard let index = nodes.firstIndex(where: { $0.id == id }) else { return }
        let coord = nodes[index].coordinate
        
        let targetLocation = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
        
        Task {
            guard let request = MKReverseGeocodingRequest(location: targetLocation) else { return }
            
            do {
                let resolvedMapItems = try await request.mapItems
                guard let mapItem = resolvedMapItems.first else { return }
                
                // Access addressRepresentations strings
                let structuralRepresentations = mapItem.addressRepresentations
                let timeZoneRepresentation = mapItem.timeZone
                
                await MainActor.run {
                    if let idx = nodes.firstIndex(where: { $0.id == id }) {
                        let city = structuralRepresentations?.cityName ?? "UNKNOWN CITY"
                        let state = structuralRepresentations?.regionName ?? "UNKNOWN STATE"
                        let country = structuralRepresentations?.region?.identifier ?? "UNKNOWN COUNTRY"
                        let area = mapItem.name ?? "UNKNOWN SECTOR"
                        
                        // Directly update properties without touching selectedNodeID
                        nodes[idx].landmark = area.uppercased()
                        nodes[idx].cityName = city.uppercased()
                        nodes[idx].zone = state.uppercased()
                        nodes[idx].countryCode = country.uppercased()
                        nodes[idx].timeZone = timeZoneRepresentation                        
                    }
                }
            } catch {
                print("TACTICAL TELEMETRY FAILURE: Reverse lookup error - \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    GeometricSandboxView()
}
