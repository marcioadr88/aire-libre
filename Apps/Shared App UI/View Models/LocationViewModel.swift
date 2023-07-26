//
//  LocationViewModel.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2023-05-01.
//

import SwiftUI
import CoreLocation
import MapKit
import OSLog

class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let log = Logger(subsystem: AppConstants.bundleId,
                             category: String(describing: LocationViewModel.self))
    
    @Published var location: CLLocation?
    
    private let locationManager = CLLocationManager()
    private let locationStore = LocationStore()
    
    @Published var authorizationStatus: CLAuthorizationStatus {
        didSet {
            switch authorizationStatus {
            #if os(iOS)
            case .authorizedAlways, .authorizedWhenInUse:
                isAuthorized = true
            #elseif os(macOS)
            case .authorized, .authorizedAlways:
                isAuthorized = true
            #endif

            default:
                isAuthorized = false
            }
        }
    }
    
    @Published var isAuthorized: Bool = false
    
    override init() {
        authorizationStatus = locationManager.authorizationStatus
        
        super.init()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        
        locationStore.saveLastKnwonLocation(newLocation)
        location = newLocation
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        log.error("Could not get location: \(error.localizedDescription)")
        location = locationStore.getLastKnwonLocation()
    }
    
    func startUpdatingLocation() {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            location = nil
        }
        
        authorizationStatus = manager.authorizationStatus
    }
}
