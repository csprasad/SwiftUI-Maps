//
//
//  LiveWeatherParticleView.swift
//  SwiftUI-Maps
//
/// Created by `C S Prasad` on `24/05/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
import MapKit

struct WeatherSimulationView: View {
    @StateObject private var engine = WeatherEngine()
    @State private var selectedWeather: WeatherType = .rain
    
    @State private var cameraPosition: MapCameraPosition = .camera(
        MapCamera(
            centerCoordinate: CLLocationCoordinate2D(latitude: 40.7588, longitude: -73.9851),
            distance: 1800,
            heading: 25,
            pitch: 60
        )
    )
    
    var body: some View {
        ZStack(alignment: .top) {
            Map(position: $cameraPosition, interactionModes: .all) {
                MapCircle(center: CLLocationCoordinate2D(latitude: 40.7588, longitude: -73.9851), radius: 250)
                    .foregroundStyle(.green.opacity(0.04))
                    .stroke(.green.opacity(0.35), lineWidth: 1.5)
            }
            .mapStyle(.standard(
                elevation: .realistic,
                pointsOfInterest: .excludingAll
            ))
            .ignoresSafeArea()
            .overlay {
                TimelineView(.animation(minimumInterval: 1 / 60)) { timeline in
                    GeometryReader { geo in
                        Canvas { context, size in
                            context.blendMode = .screen
                            
                            for particle in engine.particles where particle.opacity > 0 {
                                var path = Path()
                                
                                let isSnow = selectedWeather == .snow
                                let width = isSnow ? particle.size * 2.2 : particle.size
                                let height = isSnow ? particle.size * 2.2 : particle.size * engine.currentStretch
                                
                                if selectedWeather == .wind {
                                    path.addRoundedRect(
                                        in: CGRect(
                                            x: particle.position.x,
                                            y: particle.position.y,
                                            width: particle.size * 35,
                                            height: 3.5 + (particle.size * 1.5)
                                        ),
                                        cornerSize: CGSize(width: 4, height: 4)
                                    )
                                } else {
                                    path.addRoundedRect(
                                        in: CGRect(x: particle.position.x, y: particle.position.y, width: width, height: height),
                                        cornerSize: CGSize(width: 4, height: 4)
                                    )
                                }
                                
                                let opacity = selectedWeather == .wind ? particle.opacity * 0.35 : particle.opacity * 0.85
                                context.opacity = opacity
                                context.fill(path, with: .color(selectedWeather.color))
                            }
                        }
                        .blur(radius: selectedWeather == .wind ? 1.5 : (selectedWeather == .snow ? 0.5 : 0))
                        .onChange(of: timeline.date) { _, _ in
                            engine.updateFrame(in: geo.size, targetWeather: selectedWeather)
                        }
                    }
                }
                .allowsHitTesting(false) // Ensures touch events pass through to the Map layer
            }
            
            // Connected Weather Console UI layer
            WeatherConsoleController(selectedWeather: $selectedWeather)
                .padding(.horizontal, 16)
                .padding(.top, 64)
        }
        .preferredColorScheme(.dark)
    }
}
