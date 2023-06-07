//
//  Utils.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2023-05-24.
//

import Foundation
import CoreLocation

final class Utils {
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

extension Utils {
    static func widgetOpenURL(for source: String) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = AppConstants.scheme
        
        urlComponents.queryItems = [
            URLQueryItem(name: AppConstants.selectedSourceQueryParam,
                         value: source)
        ]
        
        return urlComponents.url
    }
    
    static func source(forWidgetOpenURL url: URL) -> String? {
        guard url.scheme == AppConstants.scheme else {
            return nil
        }
        
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItems = components?.queryItems
        
        let queryParam = queryItems?.first(where: {
            $0.name == AppConstants.selectedSourceQueryParam
        })
        
        return queryParam?.value
    }
}
