//
//
//  TacticalPinView.swift
//  SwiftUI-Maps
//
/// Created by `C S Prasad` on `01/06/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

struct TacticalPinView: View {
    let node: TacticalNode
    let isSelected: Bool

    var body: some View {
        ZStack(alignment: .center) {

            // Core Radar Circle (Aligns 1:1 to polygon lines)
            ZStack {
                Circle()
                    .fill(isSelected ? Color.purple.opacity(0.3) : Color.cyan.opacity(0.2))
                    .frame(width: 28, height: 28)

                Circle()
                    .fill(isSelected ? Color.purple : Color.cyan)
                    .frame(width: 12, height: 12)
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .shadow(color: isSelected ? .purple : .cyan, radius: 5)
            }
            .frame(width: 28, height: 28)

            // Name Banner
            if isSelected {
                Text(node.cityName)
                    .font(.system(size: 9, weight: .bold, design: .monospaced))
                    .foregroundColor(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.black.opacity(0.85))
                    .cornerRadius(4)
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(.white.opacity(0.15), lineWidth: 1))
                    .offset(y: 24)
                    .fixedSize()
            }
        }
        .frame(width: 28, height: 28, alignment: .center)
        .scaleEffect(isSelected ? 1.15 : 1.0)
    }
}
