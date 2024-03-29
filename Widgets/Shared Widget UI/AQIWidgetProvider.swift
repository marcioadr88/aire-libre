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
    private let log = Logger(subsystem: AppConstants.bundleId,
                             category: String(describing: AQIWidgetProvider.self))
    
    private let locationManager = CLLocationManager()
    private var completionCallback: ((Timeline<AQIEntry>) -> ())?
    private var cancellables = Set<AnyCancellable>()
    private let repository: AireLibreRepository
    private let locationStore: LocationStore
    
    override init() {
        let endpoints = ProductionEndpoints()
        
        #if os(watchOS)
        let connectionChecker = HttpConnectionChecker(endpoints: endpoints)
        #else
        let connectionChecker = NWPathMonitorConnectionChecker()
        #endif
        
        let networkService = NetworkServiceImpl(endpoints: endpoints)
        let persistenceService = PersistenceServiceImpl()
        locationStore = LocationStore()
        repository = AireLibreRepositoryImpl(networkService: networkService,
                                             persistenceService: persistenceService,
                                             connectionChecker: connectionChecker)
        
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
    }
    
    func placeholder(in context: Context) -> AQIEntry {
        AQIEntry.placeholder()
    }
    
    func getSnapshot(in context: Context, completion: @escaping (AQIEntry) -> ()) {
        Task(priority: .background) {
            let snapshotEntry = await getSnapshotEntry()
            completion(snapshotEntry)
        }
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<AQIEntry>) -> ()) {
        completionCallback = completion
        locationManager.startUpdatingLocation()
    }
    
    func getTimeline(location: CLLocation?,
                     completion: @escaping (Timeline<AQIEntry>) -> ()) {
        completionCallback = nil
        
        Task(priority: .background) {
            var entries: [AQIEntry] = []
            
            do {
                let aqiData = try await repository
                    .getAQI(minutesAgo: AppConstants.defaultMinutesAgo,
                            end: nil,
                            latitude: nil,
                            longitude: nil,
                            distance: nil,
                            source: nil)
                
                log.debug("fetched \(aqiData.count) elements")
                
                if let location,
                   let nearestSensor = LocationUtils.nearestSensorToUser(location,
                                                                         data: aqiData) {
                    log.info("nearest sensor to user is: \(nearestSensor.description)")
                    
                    let sensorEntry = AQIEntry(date: Date(),
                                               source: nearestSensor.source,
                                               location: nearestSensor.description,
                                               aqiIndex: nearestSensor.quality.index,
                                               isUserLocation: true)
                    entries.append(sensorEntry)
                } else {
                    let errorEntry = AQIEntry(date: Date(),
                                              withError: Localizables.errorWhileRetrievingLocation)
                    entries.append(errorEntry)
                }
            } catch {
                log.error("Error while getting aqi data \(error.localizedDescription)")
                let errorEntry = AQIEntry(date: Date(),
                                          withError: error.localizedDescription)
                entries.append(errorEntry)
            }
            
            let timeline = Timeline(entries: entries, policy: .atEnd)
            
            completion(timeline)
        }
    }
    
    private func getSnapshotEntry() async -> AQIEntry {
        let aqiData = try? await repository
            .getAQI(minutesAgo: AppConstants.defaultMinutesAgo,
                    end: nil,
                    latitude: nil,
                    longitude: nil,
                    distance: nil,
                    source: nil)
        
        log.debug("fetched \(aqiData?.count ?? 0) elements for snapshot")
        
        let snapshotEntry = aqiData?.randomElement().map {
            AQIEntry(date: Date(),
                     source: $0.source,
                     location: $0.description,
                     aqiIndex: $0.quality.index,
                     isUserLocation: false)
        }
        
        return snapshotEntry ?? AQIEntry.placeholder()
    }
    
    private func completeTimelineWithFatalError(withMessage message: String) {
        let errorEntry = AQIEntry(date: Date(),
                                  withFatalErrorMessage: message)
        let timeline = Timeline(entries: [errorEntry], policy: .atEnd)
        
        completionCallback?(timeline)
        completionCallback = nil
    }
}

extension AQIWidgetProvider: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        locationManager.stopUpdatingLocation()
        
        locationStore.saveLastKnwonLocation(location)
        getTimeline(location: location,
                    completion: completionCallback ?? { _ in })
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        log.error("Could not get location: \(error.localizedDescription)")
        locationManager.stopUpdatingLocation()
        
        let lastKnwonLocation = locationStore.getLastKnwonLocation()
        getTimeline(location: lastKnwonLocation,
                    completion: completionCallback ?? { _ in })
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
            completeTimelineWithFatalError(withMessage: Localizables.turnOnLocationToGetData)
        }
    }
}
