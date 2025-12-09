//
//  Untitled.swift
//  SwiftUI-Maps
//
//  Created by codeAlligator on 10/12/25.
//

import SwiftUI

struct FriendMarkerView: View {
    let friend: Friend
    
    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .fill(.background)
                    .frame(width: 46, height: 46)
                    .shadow(radius: 4)
                
                FriendAvatar(url: friend.imageURL, size: 40)
            }
            
            RoundedRectangle(cornerRadius: 8)
                .frame(width: 4, height: 12)
        }
    }
}
