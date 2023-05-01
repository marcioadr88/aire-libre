//
//  MapScreenViewModel.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2023-03-16.
//

import Foundation
import CoreLocation
import MapKit
import SwiftUI
import OSLog

class MapScreenViewModel: NSObject, ObservableObject {
    private let log = Logger(subsystem: "mapvm.re.airelib.ios",
                             category: String(describing: MapScreenViewModel.self))
    
    private let locationManager: CLLocationManager
    private var updateRegionWithUserLocationOnNextUpdate = false
    private let zoomFactor: CGFloat = 1.5
    private let savePath = URL.documentsDirectory.appending(path: MapScreenViewModel.regionStoreKey)
    
    @Published var region = MKCoordinateRegion(center: AppConstants.asuncionCoordinates,
                                               span: AppConstants.defaultSpan) {
        didSet {
            saveRegion()
        }
    }
    
    @Published var selectedData: AQIData?
    
    @Published var location: CLLocation? {
        didSet {
            log.debug("User location updated to \(self.location)")
        }
    }
    
    override init() {
        self.locationManager = CLLocationManager()
        
        super.init()
        
        self.locationManager.delegate = self
        
        loadSavedRegion()
    }
    
    func centerToUserLocation() {
        guard !updateRegionWithUserLocationOnNextUpdate else { return }
        
        updateRegionWithUserLocationOnNextUpdate = true
        determineUserAuthorizationStatus()
    }
    
    func zoomIn() {
        region.span.latitudeDelta *= 1/zoomFactor
        region.span.longitudeDelta *= 1/zoomFactor
    }
    
    func zoomOut() {
        region.span.latitudeDelta *= zoomFactor
        region.span.longitudeDelta *= zoomFactor
    }
}

// MARK: User location permissions
extension MapScreenViewModel: CLLocationManagerDelegate {
    func determineUserAuthorizationStatus() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            updateLocations()
        case .restricted, .denied:
            break
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            updateLocations()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
        
        if updateRegionWithUserLocationOnNextUpdate {
            updateRegionWithUserLocationOnNextUpdate.toggle()
            
            if let currentLocation = locations.last {
//                withAnimation {
                    region.center = currentLocation.coordinate
//                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        log.error("Could not get location: \(error.localizedDescription)")
    }
    
    func updateLocations() {
        locationManager.requestLocation()
    }
}

// MARK: Last used region persistence
extension MapScreenViewModel {
    private static let regionStoreKey = "MapScreenRegion"
    
    func loadSavedRegion() {
        if let data = try? Data(contentsOf: savePath) {
            if let decoded = try? JSONDecoder()
                .decode(MKCoordinateRegion.self, from: data) {
                region = decoded
            }
        }
    }
    
    func saveRegion() {
        DispatchQueue.global(qos: .background).async { [savePath, region] in
            let data = try? JSONEncoder().encode(region)
            try? data?.write(to: savePath)
        }
    }
}
