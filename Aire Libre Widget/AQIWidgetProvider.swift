//
//  Aire_Libre_Widget.swift
//  Aire Libre Widget
//
//  Created by Marcio Duarte on 2023-05-03.
//

import WidgetKit
import SwiftUI
import CoreLocation
import Combine
import OSLog

final class AQIWidgetProvider: NSObject, TimelineProvider {
    private let log = Logger(subsystem: "widgetprovider.re.airelib.ios",
                             category: String(describing: AQIWidgetProvider.self))
    
    private let locationManager = CLLocationManager()
    private var completionCallback: ((Timeline<AQIEntry>) -> ())?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func placeholder(in context: Context) -> AQIEntry {
        AQIEntry(date: Date(), location: "Placeholder", aqiIndex: 0)
    }

    func getSnapshot(in context: Context, completion: @escaping (AQIEntry) -> ()) {
        let entry = AQIEntry(date: Date(), location: "Snapshot", aqiIndex: 0)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<AQIEntry>) -> ()) {
        completionCallback = completion
        locationManager.startUpdatingLocation()
    }
    
    func getTimeline(location: CLLocation, completion: @escaping (Timeline<AQIEntry>) -> ()) {
        log.info("getTimeline with location \(location)")
        
        let entries: [AQIEntry] = [
            AQIEntry(date: Date(), location: "Entry 2", aqiIndex: 10),
            AQIEntry(date: Date(), location: "Entry 3", aqiIndex: 20),
        ]

        let timeline = Timeline(entries: entries, policy: .atEnd)
        
        locationManager.stopUpdatingLocation()
        completion(timeline)
    }
}

extension AQIWidgetProvider: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        
        getTimeline(location: newLocation) { [weak self] entry in
            self?.completionCallback?(entry)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        log.error("Could not get location: \(error.localizedDescription)")
    }
    
    func startUpdatingLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }
}
