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
    /// Requests When In Use authorization from the system, checks the current authorization status, and calls `startUpdatingLocation()` when the status is `.authorizedWhenInUse` or `.authorizedAlways`.
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
    /// - Parameter manager: The `CLLocationManager` whose authorization status changed. When the status is `.authorizedWhenInUse` or `.authorizedAlways` this method starts location updates; when the status is `.denied` or `.restricted` it stops location updates. For `.notDetermined` and unknown cases, no action is taken.
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
    ///   - locations: An array of `CLLocation` objects representing the received location updates; the most recent location is taken from the array's last element.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.lastLocation = location
        }
    }
}
