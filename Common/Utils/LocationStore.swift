//
//  LocationStore.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2023-06-16.
//

import Foundation
import CoreLocation
import OSLog

final class LocationStore {
    private let log = Logger(subsystem: "locationstore.re.airelib.ios",
                             category: String(describing: LocationStore.self))
    
    private static let savedLocationKey = "LastKnwonLocation"
    
    func saveLastKnwonLocation(_ location: CLLocation) {
        let userDefaults = UserDefaults.standard
        
        do {
            let locationData = try NSKeyedArchiver.archivedData(withRootObject: location,
                                                                requiringSecureCoding: false)
            userDefaults.set(locationData,
                             forKey: LocationStore.savedLocationKey)
            log.debug("LastKnwonLocation saved")
        } catch {
            log.error("Error saving location \(error.localizedDescription)")
        }
    }
    
    func getLastKnwonLocation() -> CLLocation? {
        let userDefaults = UserDefaults.standard
        
        if let savedLocationData = userDefaults.data(forKey: LocationStore.savedLocationKey) {
            do {
                let location = try NSKeyedUnarchiver.unarchivedObject(ofClass: CLLocation.self,
                                                                      from: savedLocationData)
                log.debug("LastKnwonLocation retrieved")
                return location
            } catch {
                log.error("Error retrieving location: \(error.localizedDescription)")
            }
        }
        
        return nil
    }
}
