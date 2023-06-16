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
}
