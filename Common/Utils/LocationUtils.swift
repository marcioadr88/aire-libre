//
//  LocationUtils.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2023-06-16.
//

import Foundation
import CoreLocation

final class LocationUtils {
    private init() {}
    
    static func nearestSensorToUser(_ location: CLLocation,
                                    data: [AQIData]) -> AQIData? {
        var nearestSensor: AQIData?
        var smallestDistance = CLLocationDistanceMax
        
        for sensor in data {
            let sensorLocation = CLLocation(latitude: sensor.latitude,
                                            longitude: sensor.longitude)
            let distance = location.distance(from: sensorLocation)
            if distance < smallestDistance {
                smallestDistance = distance
                nearestSensor = sensor
            }
        }
        
        return nearestSensor
    }
    
    static func sortByDistance(data: [AQIData],
                               to location: CLLocation) -> [AQIData] {
        let sortedData = data.sorted { (data1, data2) -> Bool in
            let location1 = CLLocation(latitude: data1.latitude, longitude: data1.longitude)
            let location2 = CLLocation(latitude: data2.latitude, longitude: data2.longitude)
            
            let distance1 = location.distance(from: location1)
            let distance2 = location.distance(from: location2)
            
            return distance1 < distance2
        }
        
        return sortedData
    }
}
