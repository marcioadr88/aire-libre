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
    let source: String?
    let location: String
    let aqiIndex: Int?
    let isUserLocation: Bool
    let error: EntryError?
    let showTimestamp: Bool
    
    private let level: AQILevel?
    
    var levelName: String? {
        level?.name
    }
    
    var levelDescription: String? {
        level?.description
    }
    
    var isError: Bool {
        error != nil
    }
    
    init(date: Date,
         source: String,
         location: String,
         aqiIndex: Int,
         isUserLocation: Bool = false,
         showTimestamp: Bool = false) {
        self.location = location
        self.aqiIndex = aqiIndex
        self.isUserLocation = isUserLocation
        self.level = AQILevel.fromIndex(aqiIndex)
        self.date = date
        self.source = source
        self.error = nil
        self.showTimestamp = showTimestamp
    }
    
    init(date: Date, withError errorMessage: String) {
        self.source = nil
        self.location = ""
        self.aqiIndex = nil
        self.isUserLocation = false
        self.level = nil
        self.date = date
        self.showTimestamp = false
        self.error = .recoverable(message: errorMessage)
    }
    
    init(date: Date, withFatalErrorMessage errorMessage: String) {
        self.source = nil
        self.date = date
        self.location = ""
        self.aqiIndex = nil
        self.isUserLocation = false
        self.level = nil
        self.showTimestamp = false
        self.error = .fatal(message: errorMessage)
    }
}

extension AQIEntry {
    static func placeholder() -> AQIEntry {
        AQIEntry(date: Date(),
                 source: "29cx2",
                 location: "Asunción",
                 aqiIndex: 0)
    }
}
