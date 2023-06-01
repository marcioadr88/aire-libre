//
//  AQIEntry.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2023-05-04.
//

import WidgetKit

enum EntryError {
    case recoverable(message: String)
    case fatal(message: String)
    
    var message: String {
        switch self {
        case .recoverable(let message):
            return message
        case .fatal(let message):
            return message
        }
    }
}

struct AQIEntry: TimelineEntry {
    let date: Date
    let location: String
    let aqiIndex: Int?
    let isUserLocation: Bool
    let error: EntryError?
    
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
        self.error = nil
    }
    
    init(date: Date, withError errorMessage: String) {
        self.location = ""
        self.aqiIndex = nil
        self.isUserLocation = false
        self.level = nil
        self.date = date
        self.error = .recoverable(message: errorMessage)
    }
    
    init(date: Date, withFatalErrorMessage errorMessage: String) {
        self.date = date
        self.location = ""
        self.aqiIndex = nil
        self.isUserLocation = false
        self.level = nil
        self.error = .fatal(message: errorMessage)
    }
}
