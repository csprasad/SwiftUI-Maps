//
//  UberRoutesView.swift
//  SwiftUI-Maps
//
//  Created by codeAlligator on 02/01/26.
//

import SwiftUI
import MapKit

struct IdentifiableMapItem: Identifiable {
    let id = UUID()
    let item: MKMapItem
}

@available(iOS 17.0, *)
struct MapSearchView: View {

    @StateObject private var locationManager = LocationManager()
    @State private var currentRegion: MKCoordinateRegion?

    // Map camera
    @State private var cameraPosition: MapCameraPosition = .automatic

    // Search
    @State private var searchText = ""
    @State private var searchResults: [MKMapItem] = []

    // Selected place
    @State private var selectedPlace: IdentifiableMapItem?

    var body: some View {
        Map(position: $cameraPosition) {
            // Selected place marker
            if let place = selectedPlace {
                // Modern iOS 26 Marker mapping via direct item location coordinates
                Marker(
                    place.item.name ?? "Place",
                    coordinate: place.item.location.coordinate
                )
            }
        }
        .mapControls {
            MapUserLocationButton()
            MapCompass()
        }
        .searchable(text: $searchText, prompt: "Search places")
        .onSubmit(of: .search) {
            performSearch()
        }
        .onChange(of: locationManager.lastLocation) { _, location in
            guard let location else { return }

            // Initial camera to user location
            cameraPosition = .region(
                MKCoordinateRegion(
                    center: location.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
            )

            currentRegion = cameraPosition.region

        }
        .onAppear {
            locationManager.start()
        }
    }

    // MARK: - Search
    private func performSearch() {
        guard !searchText.isEmpty else { return }

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = regionFromCamera()

        MKLocalSearch(request: request).start { response, _ in
            guard let response else { return }

            searchResults = response.mapItems

            if let first = searchResults.first {
                selectPlace(first)
            }
        }
    }

    // MARK: - Select place
    private func selectPlace(_ place: MKMapItem) {
        selectedPlace = IdentifiableMapItem(item: place)

        withAnimation(.easeInOut) {
            cameraPosition = .region(
                MKCoordinateRegion(
                    center: place.location.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
                )
            )
        }
    }

    /// Provides the cached camera region if available, otherwise a global fallback region.
    /// - Returns: The `currentRegion` if non-`nil`; otherwise an `MKCoordinateRegion` centered at latitude 0, longitude 0 with `latitudeDelta` and `longitudeDelta` of 180 degrees.
    private func regionFromCamera() -> MKCoordinateRegion {
        currentRegion ?? MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
            span: MKCoordinateSpan(latitudeDelta: 180, longitudeDelta: 180)
        )
    }

    /// Creates a compact detail view for the provided map place.
    /// 
    /// The view shows the place's name, its formatted address if available, and a "Close" button that clears the current selection.
    /// - Parameter place: The `MKMapItem` whose details are displayed.
    /// - Returns: A view displaying the place's name, optional address, and a Close button that clears `selectedPlace`.
    private func placeDetail(_ place: MKMapItem) -> some View {
        VStack(spacing: 12) {
            Text(place.name ?? "")
                .font(.headline)

            if let address = place.address?.fullAddress {
                Text(address)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Button("Close") {
                selectedPlace = nil
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .presentationDetents([.medium])
    }
}
