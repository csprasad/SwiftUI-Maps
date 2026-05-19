//
//  FriendAvatar.swift
//  SwiftUI-Maps
//
//  Created by codeAlligator on 10/12/25.
//

import SwiftUI

struct FriendAvatar: View {
    let url: URL
    let size: CGFloat
    
    var body: some View {
        AsyncImage(url: url, transaction: Transaction(animation: .spring())) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
            case .failure(_):
                // error placeholder
                ZStack {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                    Image(systemName: "person.fill.xmark")
                        .foregroundColor(.secondary)
                        .imageScale(.small)
                }
            case .empty:
                // loading placeholder
                ZStack {
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                    ProgressView()
                        .scaleEffect(0.7)
                }
            @unknown default:
                Color.gray.opacity(0.3)
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
    }
}

