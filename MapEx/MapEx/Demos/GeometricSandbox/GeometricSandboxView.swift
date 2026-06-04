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
    @State private var selectedNodeID: UUID?
    @State private var isInfoExpanded: Bool = false
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
                            .foregroundStyle(LinearGradient(
                                colors: [.cyan.opacity(0.18), .purple.opacity(0.04)],
                                startPoint: .top,
                                endPoint: .bottom))
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
                    Text(nodes.count >= 3 ?
                            "PERIMETER MESH ACTIVE | SECURE TRACKING SEC-METRICS" :
                            "PERIMETER UNBOUNDED: DEPLOY MINIMUM 3 NODES FOR MESH MAPPING")
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
                    TacticalInfoCard(
                        nodes: $nodes,
                        selectedNodeID: $selectedNodeID,
                        isExpanded: $isInfoExpanded,
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

    /// Update the coordinate of the tactical node matching the given identifier.
    /// If no node with the specified `id` exists, the call has no effect.
    /// - Parameters:
    ///   - id: The identifier of the node to update.
    /// Update the coordinate of the node with the specified identifier.
    /// - Parameters:
    ///   - id: The unique identifier of the node to update.
    ///   - coordinate: The new geographic coordinate to assign to the node.
    /// - Note: If no node with `id` exists, the function performs no action.
    private func updateNodeCoordinate(id: UUID, to coordinate: CLLocationCoordinate2D) {
        if let index = nodes.firstIndex(where: { $0.id == id }) {
            nodes[index].coordinate = coordinate
        }
    }

    /// Create a new tactical node at the given map coordinate, append it to the node list, select it, and initiate reverse-geocoding telemetry.
    /// - Parameters:
    /// Creates a new `TacticalNode` at the given map coordinate, appends it to `nodes`, sets it as the current selection, and initiates reverse-geocoding telemetry for that node.
    /// - Parameter coordinate: The geographic coordinate where the new node will be placed.
    private func createNewNode(at coordinate: CLLocationCoordinate2D) {
        let newNode = TacticalNode(coordinate: coordinate)
        nodes.append(newNode)
        selectedNodeID = newNode.id
        fetchGeocodingTelemetry(for: newNode.id)
    }

    /// Fetches reverse-geocoding information for the tactical node with the given `id` and updates that node's address and timezone properties on the main actor.
    /// - Parameter id: The identifier of the node to refresh; no action is taken if no matching node exists.
    /// Fetches reverse-geocoding information for a node and updates that node's address and timezone fields.
    /// - Details: Performs an asynchronous reverse-geocoding lookup for the node's current coordinate and, if the node still exists at that same coordinate when results return, updates the node's `landmark`, `cityName`, `zone`, `countryCode`, and `timeZone`. If no results are found or the node moved before the response arrives, no changes are applied; failures are logged but not thrown.
    /// - Parameter id: The UUID of the node to resolve and update.
    private func fetchGeocodingTelemetry(for id: UUID) {
        guard let index = nodes.firstIndex(where: { $0.id == id }) else { return }
        let coord = nodes[index].coordinate

        let targetLocation = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
        let expectedLocation = targetLocation

        Task {
            guard let request = MKReverseGeocodingRequest(location: targetLocation) else { return }

            do {
                let resolvedMapItems = try await request.mapItems
                guard let mapItem = resolvedMapItems.first else { return }

                // Access addressRepresentations strings
                let structuralRepresentations = mapItem.addressRepresentations
                let timeZoneRepresentation = mapItem.timeZone

                await MainActor.run {
                    guard let idx = nodes.firstIndex(where: { $0.id == id }),
                          nodes[idx].location == expectedLocation else { return }

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
            } catch {
                print("TACTICAL TELEMETRY FAILURE: Reverse lookup error - \(error.localizedDescription)")
            }
        }
    }
}
