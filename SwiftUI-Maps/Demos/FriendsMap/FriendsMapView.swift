//
//  Untitled.swift
//  SwiftUI-Maps
//
//  Created by codeAlligator on 10/12/25.
//


import SwiftUI
import MapKit

struct FriendsMapView: View {
    @StateObject private var locationManager = LocationManager()
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 40.730610, longitude: -73.935242),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    @State private var friends: [FriendMapModel] = sampleFriends
    @State private var selectedFriend: FriendMapModel?
    
    var body: some View {
        ZStack(alignment: .top) {
            mapLayer
                .ignoresSafeArea()
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.spring()) {
                        selectedFriend = nil
                    }
                }
                        
            VStack(spacing: 12) {
                ThemePickerView()
                    .padding(.horizontal)
                    .padding(.top, 8)
                
                Spacer()
                
                friendsList
                    .padding(.bottom, 16)
            }
            
            if let friend = selectedFriend {
                FriendDetailCard(friend: friend) {
                    withAnimation(.spring()) {
                        selectedFriend = nil
                    }
                }
                .padding(.horizontal)
                .padding(.top, 70)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
            
        }
        .onAppear {
            locationManager.start()      // start location after view appears
        }
        .onChange(of: locationManager.lastLocation) { location in
            guard let location else { return }
            // update region in response to changes
            DispatchQueue.main.async {
                withAnimation {
                    region = MKCoordinateRegion(
                        center: location.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
                    )
                }
            }
        }
    }
    
    // MARK: - Subviews
    
    //Map
    private var mapLayer: some View {
        Map(
            coordinateRegion: $region,
            showsUserLocation: true,
            annotationItems: friends
        ) { friend in
            MapAnnotation(coordinate: friend.coordinate) {
                FriendMarkerView(friend: friend)
                .onTapGesture {
                    withAnimation(.spring()) {
                        selectedFriend = friend
                    }
                }
            }
        }
    }
        
    // Firend List View
    private var friendsList: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Friends Nearby")
                    .font(.headline)
                Spacer()
                Button {
                    // Log current location when tapped
                    print("My Location tapped, lastLocation =", locationManager.lastLocation as Any)
                    
                    if let location = locationManager.lastLocation {
                        withAnimation {
                            region = MKCoordinateRegion(
                                center: location.coordinate,
                                span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
                            )
                        }
                    }
                } label: {
                    Label("My Location", systemImage: "location.fill")
                        .font(.subheadline)
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(friends) { friend in
                        Button {
                            withAnimation {
                                region = MKCoordinateRegion(
                                    center: friend.coordinate,
                                    span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
                                )
                                
                                selectedFriend = nil
                            }
                        } label: {
                            HStack(spacing: 8) {
                                FriendAvatar(url: friend.imageURL, size: 36)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(friend.name)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    Text("Tap to center")
                                        .font(.caption2)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .padding(8)
                            .background(.thinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .padding(12)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .padding(.horizontal)
    }
}
