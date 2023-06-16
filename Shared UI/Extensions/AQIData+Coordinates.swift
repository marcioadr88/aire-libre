//
//  AQIData+Coordinates.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2022-12-06.
//

import Foundation
import MapKit

extension AQIData {
    var coordinates: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
