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

class MapScreenViewModel: NSObject, ObservableObject {
    private let locationManager: CLLocationManager
    private var updateRegionWithUserLocationOnNextUpdate = false
    private let zoomFactor: CGFloat = 1.5
    
    @Published var region = MKCoordinateRegion(center: AppConstants.asuncionCoordinates,
                                               span: AppConstants.defaultSpan)
    @Published var selectedData: AQIData?
    
    override init() {
        self.locationManager = CLLocationManager()
        
        super.init()
        
        self.locationManager.delegate = self
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
        print("location with error")
    }
    
    func updateLocations() {
        locationManager.requestLocation()
    }
}
