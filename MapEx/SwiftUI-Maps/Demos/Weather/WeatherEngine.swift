//
//
//  WeatherEngine.swift
//  SwiftUI-Maps
//
/// Created by `C S Prasad` on `25/05/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - Engine
final class WeatherEngine {
    
    var particles: [WeatherModel] = []
    private var lastWeather: WeatherType?
    
    func updateFrame(in size: CGSize, weather: WeatherType) {
        guard size.width > 0, size.height > 0 else { return }
        
        // FULL RESET WHEN SWITCHING WEATHER
        if lastWeather != weather {
            particles.removeAll()
            particles = (0..<weather.particleCount).map { _ in
                WeatherModel(
                    position: CGPoint(x: CGFloat.random(in: 0...size.width), y: CGFloat.random(in: 0...size.height)),
                    speed: CGFloat.random(in: 0.8...1.8),
                    opacity: Double.random(in: 0.2...0.9),
                    size: CGFloat.random(in: 1.5...4),
                    phase: CGFloat.random(in: 0...(CGFloat.pi * 2))
                )
            }
            
            lastWeather = weather
        }
        
        // PARTICLE SIMULATION
        for index in particles.indices {
            
            switch weather {

            case .rain:
                particles[index].position.x += 0.15
                particles[index].position.y += 4.5 * particles[index].speed

                if particles[index].position.y > size.height + 120 {
                    particles[index].position.y = -120
                    particles[index].position.x =
                    CGFloat.random(in: -50...size.width + 50)
                }

            case .wind:
                particles[index].position.x += 2.2 * particles[index].speed

                particles[index].position.y +=
                sin(particles[index].phase) * 0.15

                particles[index].phase += 0.01

                if particles[index].position.x > size.width + 200 {
                    particles[index].position.x = -200
                    particles[index].position.y =
                    CGFloat.random(in: 0...size.height)
                }

            case .snow:
                particles[index].phase += 0.015

                particles[index].position.x +=
                sin(particles[index].phase) * 0.45

                particles[index].position.y +=
                0.9 * particles[index].speed

                if particles[index].position.y > size.height + 120 {
                    particles[index].position.y = -120
                    particles[index].position.x =
                    CGFloat.random(in: -80...size.width + 80)
                }
            }
        }
    }
}
