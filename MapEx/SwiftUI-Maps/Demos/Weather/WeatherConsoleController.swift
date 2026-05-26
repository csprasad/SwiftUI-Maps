//
//
//  WeatherConsoleController.swift
//  SwiftUI-Maps
//
/// Created by `C S Prasad` on `26/05/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

struct WeatherConsoleController: View {
    @Binding var selectedWeather: WeatherType
    
    var body: some View {
        VStack(spacing: 8) {
            // Telemetry Bar
            HStack {
                Group {
                    Text("LOC: 40.7588° N, 73.9851° W")
                    Spacer()
                    Text("SYS_ALT: 1800M")
                    Spacer()
                    Text("BARO: 1013.2 HPA")
                }
                .font(.system(size: 9, weight: .semibold, design: .monospaced))
                .foregroundColor(.green.opacity(0.8))
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 10)
            .background(Color.black.opacity(0.3))
            .cornerRadius(6)
            
            // Core Control Module
            HStack(spacing: 12) {
                Label {
                    Text("MATRIX // 3D_FX")
                        .tracking(1.0)
                } icon: {
                    Image(systemName: "dot.radiowaves.up.forward")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.green)
                }
                .font(.system(.caption, design: .monospaced))
                .foregroundColor(.white.opacity(0.6))
                
                Spacer()
                
                Button {
                    withAnimation(.spring(response: 0.22, dampingFraction: 0.8)) {
                        cycleWeather()
                    }
                } label: {
                    HStack(spacing: 8) {
                        Circle()
                            .fill(weatherColor)
                            .frame(width: 5, height: 5)
                            .shadow(color: weatherColor, radius: 4)
                        
                        Text(selectedWeather.rawValue.uppercased())
                            .font(.system(.caption, design: .monospaced))
                            .fontWeight(.black)
                            .foregroundColor(.white)
                        
                        Image(systemName: weatherIcon)
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(weatherColor)
                            .contentTransition(.symbolEffect(.replace))
                    }
                    .padding(.vertical, 6)
                    .padding(.horizontal, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                            .fill(Color.white.opacity(0.04))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                            .stroke(Color.white.opacity(0.08), lineWidth: 1)
                    )
                }
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
        )
    }
    
    private func cycleWeather() {
        let all = WeatherType.allCases
        if let currentIdx = all.firstIndex(of: selectedWeather) {
            let nextIdx = (currentIdx + 1) % all.count
            selectedWeather = all[nextIdx]
        }
    }
    
    private var weatherIcon: String {
        switch selectedWeather {
        case .rain: return "cloud.rain.fill"
        case .wind: return "wind"
        case .snow: return "snowflake"
        }
    }
    
    private var weatherColor: Color {
        switch selectedWeather {
        case .rain: return .cyan
        case .wind: return .blue
        case .snow: return .white
        }
    }
}
