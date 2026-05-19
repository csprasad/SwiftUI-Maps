//
//  FriendDetailCard.swift
//  SwiftUI-Maps
//
//  Created by codeAlligator on 10/12/25.
//

import SwiftUI

struct FriendDetailCard: View {
    let friend: FriendMapModel
    let onClose: () -> Void
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            FriendAvatar(url: friend.imageURL, size: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                
                HStack(alignment: .bottom, spacing: 4) {
                    Text(friend.name)
                        .font(.headline)
                    Spacer()
                    Text("Online")
                        .font(.caption)
                        .foregroundStyle(.green)
                }
                
                Text("Last seen nearby \(friend.place)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text("Some short description or status goes here.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Button(action: onClose) {
                Image(systemName: "xmark.circle.fill")
                    .imageScale(.large)
                    .foregroundStyle(.gray)
            }
        }
        .padding(12)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(radius: 8)
    }
}

