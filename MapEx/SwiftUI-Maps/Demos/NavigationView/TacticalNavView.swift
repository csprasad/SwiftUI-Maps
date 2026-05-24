//
//
//  CyberpunkMapView.swift
//  SwiftUI-Maps
//
/// Created by `C S Prasad` on `22/05/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
import MapKit
internal import Combine

enum NavState {
    case initialization
    case routePlotting
    case activeSimulation
}

struct TacticalNavView: View {
    // DESTINATION TRACK (Times Square to Central Park Area)
    private let originPoint = CLLocationCoordinate2D(latitude: 40.7580, longitude: -73.9855)
    private let targetPoint = CLLocationCoordinate2D(latitude: 40.7712, longitude: -73.9782)
    
    // Core Navigation Parameters
    @State private var position: MapCameraPosition = .automatic
    @State private var simState: NavState = .initialization
    @State private var streetWaypoints: [CLLocationCoordinate2D] = []
    
    // Live Telemetry States
    @State private var currentVehiclePos: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 40.7580, longitude: -73.9855)
    @State private var lineProgress: Double = 0.0
    @State private var arrayIndex: Int = 0
    @State private var stepProgress: Double = 0.0
    
    // Heading Gimbal Filter States
    @State private var targetHeading: Double = 26.0
    @State private var smoothHeading: Double = 26.0
    
    // Live Simulation HUD Computations
    @State private var totalDistanceLeft: String = "Calculating..."
    @State private var simulatedETA: String = "00:00"
    
    private let frameTimer = Timer.publish(every: 0.016, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            // True Midnight Slate Backing
            Color(red: 0.005, green: 0.008, blue: 0.015)
                .ignoresSafeArea()
            
            Map(position: $position, interactionModes: simState == .activeSimulation ? [] : .all) {
                // NEON ROUTE PATH MATRIX
                if !streetWaypoints.isEmpty {
                    MapPolyline(coordinates: getRenderedLinePoints())
                        .stroke(
                            LinearGradient(
                                colors: [Color(red: 0.0, green: 0.8, blue: 1.0), Color(red: 0.5, green: 0.0, blue: 1.0)],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round)
                        )
                }
                
                // TIMELINE MARKERS
                Annotation(coordinate: originPoint) {
                    Circle()
                        .stroke(Color.cyan, lineWidth: 2)
                        .frame(width: 16, height: 16)
                        .background(Circle().fill(Color.black))
                } label: { Text("ORIGIN") }
                
                Annotation(coordinate: targetPoint) {
                    Image(systemName: "triangle.fill")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.purple)
                        .shadow(color: .purple, radius: 4)
                } label: { Text("TERM") }
                
                // SYNCHRONIZED VEHICLE INDICATOR
                if simState == .activeSimulation {
                    Annotation(coordinate: currentVehiclePos) {
                        ZStack {
                            Circle()
                                .fill(Color.cyan.opacity(0.25))
                                .frame(width: 44, height: 44)
                            
                            // Directional pointer matching the smoothed chassis orientation
                            Image(systemName: "location.north.fill")
                                .font(.system(size: 18, weight: .black))
                                .foregroundColor(.white)
                                .shadow(color: .cyan, radius: 4)
                                .rotationEffect(.degrees(smoothHeading))
                        }
                    } label: { EmptyView() }
                }
            }
            .mapStyle(.standard(elevation: .realistic, emphasis: .muted, pointsOfInterest: []))
            .colorScheme(.dark)
            .overlay {
                // Midnight Tech Overlay Matrix
                ZStack {
                    Color.white.blendMode(.difference)
                    Color(red: 0.02, green: 0.08, blue: 0.22).blendMode(.color)
                    Color(red: 0.01, green: 0.04, blue: 0.12).blendMode(.screen)
                }
                .allowsHitTesting(false)
            }
            .ignoresSafeArea()
            
            // LIVE NAVIGATION HUD PANEL
            VStack {
                Spacer()
                
                VStack(spacing: 14) {
                    // Top Scanline Banner
                    HStack {
                        HStack(spacing: 6) {
                            Circle()
                                .fill(simState == .activeSimulation ? Color.green : Color.orange)
                                .frame(width: 6, height: 6)
                            Text(simState == .activeSimulation ? "NAVIGATION SIMULATOR ACTIVE" : "SYSTEM CALIBRATION...")
                                .font(.system(.caption, design: .monospaced))
                                .fontWeight(.bold)
                                .foregroundColor(simState == .activeSimulation ? .green : .orange)
                        }
                        Spacer()
                        Text("SYS_LOC: NYC_GRID")
                            .font(.system(.caption2, design: .monospaced))
                            .foregroundColor(.white.opacity(0.4))
                    }
                    
                    Divider()
                        .background(Color.white.opacity(0.1))
                    
                    // Main Telemetry Readouts
                    HStack(spacing: 24) {
                        // Estimated Arrival Column
                        VStack(alignment: .leading, spacing: 2) {
                            Text("EST ARRIVAL")
                                .font(.system(.caption2, design: .monospaced))
                                .foregroundColor(.white.opacity(0.4))
                            Text(simulatedETA)
                                .font(.system(.title3, design: .monospaced))
                                .fontWeight(.black)
                                .foregroundColor(.white)
                        }
                        
                        // Remaining Distance Column
                        VStack(alignment: .leading, spacing: 2) {
                            Text("DISTANCE LEFT")
                                .font(.system(.caption2, design: .monospaced))
                                .foregroundColor(.white.opacity(0.4))
                            Text(totalDistanceLeft)
                                .font(.system(.title3, design: .monospaced))
                                .fontWeight(.black)
                                .foregroundColor(.cyan)
                        }
                        
                        Spacer()
                        
                        // Vehicle Velocity Vector Graph
                        HStack(alignment: .bottom, spacing: 3) {
                            ForEach(0..<5) { index in
                                RoundedRectangle(cornerRadius: 1)
                                    .fill(simState == .activeSimulation ? Color.cyan.opacity(0.8) : Color.white.opacity(0.2))
                                    .frame(width: 4, height: CGFloat((index + 1) * 6))
                            }
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(red: 0.01, green: 0.02, blue: 0.05).opacity(0.92))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.cyan.opacity(0.2), lineWidth: 1)
                )
                .padding()
            }
        }
        .onAppear {
            requestSystemRouteData()
        }
        .onReceive(frameTimer) { _ in
            if simState == .activeSimulation {
                stepSimulationLocomotion()
            }
        }
    }
    
    //MARK: - OUTER PIPELINES
    private func requestSystemRouteData() {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: originPoint))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: targetPoint))
        request.transportType = .walking
        
        Task {
            let directions = MKDirections(request: request)
            do {
                let response = try await directions.calculate()
                guard let route = response.routes.first else { return }
                
                let pointCount = route.polyline.pointCount
                var coords = [CLLocationCoordinate2D](repeating: CLLocationCoordinate2D(), count: pointCount)
                route.polyline.getCoordinates(&coords, range: NSRange(location: 0, length: pointCount))
                
                await MainActor.run {
                    self.streetWaypoints = coords
                    triggerBriefingAnimation()
                }
            } catch {
                print("Telemetry trace dropped: \(error.localizedDescription)")
            }
        }
    }
    
    private func triggerBriefingAnimation() {
        simState = .routePlotting
        lineProgress = 0.0
        currentVehiclePos = originPoint
        
        // Framework overhead 2D tactical layout frame
        position = .camera(
            MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: 40.7645, longitude: -73.9820), distance: 3000, heading: 0, pitch: 0)
        )
        
        withAnimation(.linear(duration: 2.2)) {
            lineProgress = 1.0
        }
        
        // Swoop into active driver tracking frame
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            if streetWaypoints.count > 1 {
                targetHeading = calculateBearingAngle(from: streetWaypoints[0], to: streetWaypoints[1])
                smoothHeading = targetHeading
            }
            
            withAnimation(.easeInOut(duration: 2.0)) {
                position = .camera(
                    MapCamera(centerCoordinate: originPoint, distance: 150, heading: smoothHeading, pitch: 84)
                )
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                arrayIndex = 0
                stepProgress = 0.0
                simState = .activeSimulation
            }
        }
    }
    
    //MARK: - Simulation
    private func stepSimulationLocomotion() {
        let terminalBound = streetWaypoints.count - 1
        guard arrayIndex < terminalBound else {
            // Loop navigation telemetry infinitely
            triggerBriefingAnimation()
            return
        }
        
        stepProgress += 0.03
        
        if stepProgress >= 1.0 {
            stepProgress = 0.0
            arrayIndex += 1
            updateTelemetryCalculations()
            return
        }
        
        let p1 = streetWaypoints[arrayIndex]
        let p2 = streetWaypoints[arrayIndex + 1]
        
        let intermediateLat = p1.latitude + (p2.latitude - p1.latitude) * stepProgress
        let intermediateLon = p1.longitude + (p2.longitude - p1.longitude) * stepProgress
        let calculatedPos = CLLocationCoordinate2D(latitude: intermediateLat, longitude: intermediateLon)
        
        currentVehiclePos = calculatedPos
        
        // Low Pass Angular Smoothing Filter
        let rawHeading = calculateBearingAngle(from: p1, to: p2)
        targetHeading = rawHeading
        
        var angularDiff = targetHeading - smoothHeading
        while angularDiff < -180 { angularDiff += 360 }
        while angularDiff > 180  { angularDiff -= 360 }
        smoothHeading += angularDiff * 0.075 // Eases camera into street changes smoothly
        
        // Render current perspective straight down the lane vectors
        position = .camera(
            MapCamera(
                centerCoordinate: calculatedPos,
                distance: 150,          // Close windshield proximity ground altitude
                heading: smoothHeading, // Gimbal tracked
                pitch: 84               // True horizon lock
            )
        )
    }
    
    //MARK: - HUD DATA MATRICES WORKFLOWS
    private func updateTelemetryCalculations() {
        let totalElements = streetWaypoints.count
        let itemsRemaining = totalElements - arrayIndex
        
        // Simulate a true live distance estimation (approx 15 meters per coordinate chunk element)
        let totalMetersLeft = Double(itemsRemaining) * 14.5
        if totalMetersLeft > 1000 {
            totalDistanceLeft = String(format: "%.2f KM", totalMetersLeft / 1000.0)
        } else {
            totalDistanceLeft = String(format: "%.0f METERS", totalMetersLeft)
        }
        
        // Calculate a realistic time arrival matrix using system clocks
        let estimatedSecondsRemaining = Int(totalMetersLeft / 4.2)
        let calendar = Calendar.current
        if let calculatedDate = calendar.date(byAdding: .second, value: estimatedSecondsRemaining, to: Date()) {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss"
            simulatedETA = formatter.string(from: calculatedDate)
        }
    }
    
    private func getRenderedLinePoints() -> [CLLocationCoordinate2D] {
        if simState == .routePlotting {
            let limit = Int(lineProgress * Double(streetWaypoints.count))
            return Array(streetWaypoints.prefix(max(1, limit)))
        }
        return streetWaypoints
    }
    
    private func calculateBearingAngle(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Double {
        let lat1 = from.latitude * .pi / 180
        let lon1 = from.longitude * .pi / 180
        let lat2 = to.latitude * .pi / 180
        let lon2 = to.longitude * .pi / 180
        
        let deltaLon = lon2 - lon1
        let y = sin(deltaLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(deltaLon)
        let degrees = (atan2(y, x) * 180 / .pi + 360).truncatingRemainder(dividingBy: 360)
        return degrees
    }
}
