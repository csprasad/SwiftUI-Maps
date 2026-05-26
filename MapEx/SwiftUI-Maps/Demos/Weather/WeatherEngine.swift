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
internal import Combine

// MARK: - Engine
final class WeatherEngine: ObservableObject {
    @Published var particles: [WeatherModel] = []
    private var isInitialized = false
    
    // tracking vectors
    var currentVelocity = CGPoint(x: 0.2, y: 6.0)
    var currentStretch: CGFloat = 8.0
    
    func updateFrame(in size: CGSize, targetWeather: WeatherType) {
        guard size.width > 0, size.height > 0 else { return }
        
        // Initial Pass
        if !isInitialized {
            particles = (0..<250).map { _ in
                WeatherModel(
                    position: CGPoint(x: CGFloat.random(in: 0...size.width), y: CGFloat.random(in: 0...size.height)),
                    speed: CGFloat.random(in: 0.8...2.2),
                    opacity: Double.random(in: 0.15...0.7),
                    size: CGFloat.random(in: 1.0...2.5),
                    phase: CGFloat.random(in: 0...(CGFloat.pi * 2))
                )
            }
            isInitialized = true
            return
        }
        
        // Interpolation (Lerp Math)
        currentVelocity.x += (targetWeather.targetVelocity.x - currentVelocity.x) * 0.06
        currentVelocity.y += (targetWeather.targetVelocity.y - currentVelocity.y) * 0.06
        currentStretch += (targetWeather.particleStretch - currentStretch) * 0.06
        
        // Update Loop
        let activeCount = min(targetWeather.maxParticles, particles.count)
        
        for index in 0..<particles.count {
            if index >= activeCount {
                particles[index].opacity = max(0, particles[index].opacity - 0.02)
            } else if particles[index].opacity < 0.15 {
                particles[index].opacity = Double.random(in: 0.15...0.7)
            }
            
            // Apply velocities modulated by unique particle speeds
            particles[index].position.x += currentVelocity.x * particles[index].speed
            particles[index].position.y += currentVelocity.y * particles[index].speed
            
            // Secondary oscillation math for wind and snow drift profiles
            if targetWeather == .wind || targetWeather == .snow {
                particles[index].phase += 0.02
                if targetWeather == .wind {
                    particles[index].position.y += sin(particles[index].phase) * 0.3
                } else {
                    particles[index].position.x += sin(particles[index].phase) * 0.5
                }
            }
            
            // Bounding box
            recycleIfNeeded(at: index, in: size, mode: targetWeather)
        }
    }
    
    private func recycleIfNeeded(at index: Int, in size: CGSize, mode: WeatherType) {
        if mode == .wind {
            if particles[index].position.x > size.width + 100 {
                particles[index].position.x = -50
                particles[index].position.y = CGFloat.random(in: -20...size.height + 20)
            }
        } else {
            if particles[index].position.y > size.height + 50 || particles[index].position.x > size.width + 50 || particles[index].position.x < -50 {
                particles[index].position.y = -20
                particles[index].position.x = CGFloat.random(in: -20...size.width + 20)
            }
        }
    }
}
