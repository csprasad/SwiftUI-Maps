//
//  LocationManager.swift
//  SwiftUI-Maps
//
//  Created by codeAlligator on 10/12/25.
//

import Foundation
import CoreLocation
internal import Combine

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()

    @Published var lastLocation: CLLocation?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    /// Requests "When In Use" location authorization and starts location updates if the app is already authorized.
    /// 
    /// Requests "When In Use" location authorization and, if the manager is already authorized, begins updating location.
    /// 
    /// If the current authorization status is `.authorizedWhenInUse` or `.authorizedAlways`, `startUpdatingLocation()` is invoked; otherwise no updates are started.
    func start() {
        manager.requestWhenInUseAuthorization()

        // Debug
        print("start() called, status:", manager.authorizationStatus.rawValue)

        let status = manager.authorizationStatus
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager.startUpdatingLocation()
        }
    }

    /// Handles changes to the location authorization status and starts or stops location updates accordingly.
    /// Handles changes to location authorization status and updates the location manager accordingly.
    /// Starts location updates when authorization is `.authorizedWhenInUse` or `.authorizedAlways`, stops updates when `.denied` or `.restricted`, and does nothing for `.notDetermined`.
    /// - Parameter manager: The `CLLocationManager` whose authorization status changed.
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus

        // Debug
        print("didChangeAuthorization:", status.rawValue)

        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            print("Authorized, starting updates")
            manager.startUpdatingLocation()
        case .denied, .restricted:
            print("DENIED / RESTRICTED")
            manager.stopUpdatingLocation()
        case .notDetermined:
            print("notDetermined")
        @unknown default:
            break
        }
    }

    /// Handles location updates by publishing the most recent location.
    /// 
    /// If `locations` contains at least one entry, assigns the last `CLLocation` to `lastLocation` on the main queue so observers/UI receive the update. Does nothing if `locations` is empty.
    /// - Parameters:
    ///   - manager: The `CLLocationManager` that delivered the update.
    /// Updates the published `lastLocation` with the most recent `CLLocation` from an array of location updates.
    /// - Parameters:
    ///   - manager: The `CLLocationManager` that delivered the update.
    ///   - locations: An array of location updates; the function uses the most recent entry (`locations.last`) and assigns it to `lastLocation`, notifying observers.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.lastLocation = location
        }
    }
}
