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
    
    func start() {
        manager.requestWhenInUseAuthorization()
        
        //Debug
        print("start() called, status:", manager.authorizationStatus.rawValue)
                manager.requestWhenInUseAuthorization()
        
        let status = manager.authorizationStatus
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager.startUpdatingLocation()
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        //Debug
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.lastLocation = location
        }
    }
}

