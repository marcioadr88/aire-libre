//
//  AppConstants.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2022-11-23.
//

import Foundation
import CoreLocation
import MapKit

final class AppConstants {
    static let asuncionCoordinates = CLLocationCoordinate2D(latitude: -25.287385,
                                                            longitude: -57.601522)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
    static let defaultMinutesAgo: Int = 30
    static let scheme = "aire-libre"
    static let selectedSourceQueryParam = "selectedSource"
    static let bundleId = Bundle.main.bundleIdentifier ?? "re.airelib.app"
}

typealias VoidCallback = () -> Void
