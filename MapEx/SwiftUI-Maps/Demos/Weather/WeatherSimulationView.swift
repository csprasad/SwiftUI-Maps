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


// MARK: - Main Weather View
struct WeatherSimulationView: View {
    
    @State private var engine = WeatherEngine()
    @State private var selectedWeather: WeatherType = .rain
    @State private var cameraPosition: MapCameraPosition = .camera(
        MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: 40.7588, longitude: -73.9851), distance: 3500)
    )
    
    var body: some View {
        ZStack(alignment: .top) {
            
            TimelineView(.animation(minimumInterval: 1 / 60)) { timeline in
                Map(position: $cameraPosition) {
                    Marker("Times Square", coordinate: CLLocationCoordinate2D(latitude: 40.7588, longitude: -73.9851))
                }
                .mapStyle(.standard)
                .ignoresSafeArea()
                .overlay {
                    
                    GeometryReader { geo in
                        Canvas { context, size in
                            engine.updateFrame(in: size, weather: selectedWeather)
                            
                            context.blendMode = .plusLighter
                            context.addFilter(.blur(radius: 0.5))
                            
                            for particle in engine.particles {
                                
                                var path = Path()
                                let width = selectedWeather == .snow ? particle.size * 2.4 : particle.size
                                let height = selectedWeather == .snow ? particle.size * 2.4 : particle.size * selectedWeather.particleStretch
                                
                                if selectedWeather == .wind {
                                    path.addRoundedRect(in: CGRect(
                                            x: particle.position.x,
                                            y: particle.position.y,
                                            width: particle.size * 26,
                                            height: particle.size * 2.2
                                        ),
                                        cornerSize: CGSize(width: 20, height: 20)
                                    )
                                } else {
                                    path.addRoundedRect(in: CGRect(
                                            x: particle.position.x,
                                            y: particle.position.y,
                                            width: width,
                                            height: height
                                        ),
                                        cornerSize: CGSize(width: 10, height: 10)
                                    )
                                }
                                
                                let opacity =
                                selectedWeather == .wind ? particle.opacity * 0.45 : particle.opacity * 0.8
                                context.opacity = opacity
                                context.fill(path, with: .color(selectedWeather.color))
                            }
                        }
                        .blur(radius: selectedWeather == .wind ? 12 : selectedWeather == .snow ? 0.5 : 0)
                    }
                }
            }.ignoresSafeArea()
            
            // Picker Controller
            VStack {
                Picker("Weather", selection: $selectedWeather) {
                    ForEach(WeatherType.allCases) { weather in
                        Text(weather.rawValue)
                            .tag(weather)
                    }
                }
                .pickerStyle(.segmented)
                .padding(6)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .padding(.horizontal, 20)
                .padding(.top)
                
                Spacer()
            }
        }.preferredColorScheme(.dark)
    }
}
