//
//  AQIEntry.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2023-05-04.
//

import WidgetKit

struct AQIEntry: TimelineEntry {
    let date: Date
    let location: String
    let aqiIndex: Int
    let isUserLocation: Bool
    
    private let level: AQILevel?
    
    var levelName: String? {
        level?.name
    }
    
    var levelDescription: String? {
        level?.description
    }
    
    init(date: Date, location: String, aqiIndex: Int, isUserLocation: Bool = false) {
        self.location = location
        self.aqiIndex = aqiIndex
        self.isUserLocation = isUserLocation
        self.level = AQILevel.fromIndex(aqiIndex)
        self.date = date
    }
}
