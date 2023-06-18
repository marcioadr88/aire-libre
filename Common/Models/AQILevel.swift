//
//  AQILevel.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2022-12-05.
//

import Foundation
import SwiftUI

enum AQILevel: String {
    static let minAQIIndex = 0
    static let maxAQIIndex = 500
    
    case good
    case moderate
    case sensitive
    case unhealthy
    case veryUnhealthy
    case hazardous
    
    var color: Color {
        switch self {
        case .good:
            return Color.green
        case .moderate:
            return Color.yellow
        case .sensitive:
            return Color.orange
        case .unhealthy:
            return Color.red
        case .veryUnhealthy:
            return Color(hex: 0x8f3f97)
        case .hazardous:
            return Color(hex: 0x7e0023)
        }
    }
    
    static func fromIndex(_ index: Int) -> AQILevel? {
        switch index {
        case minAQIIndex...50:
            return .good
        case 51...100:
            return .moderate
        case 101...150:
            return .sensitive
        case 151...200:
            return .unhealthy
        case 201...300:
            return .veryUnhealthy
        case 301...maxAQIIndex:
            return .hazardous
        default:
            return nil
        }
    }
}

extension AQILevel {
    var range: ClosedRange<Int> {
        switch self {
        case .good:
            return 0...50
        case .moderate:
            return 51...100
        case .sensitive:
            return 101...150
        case .unhealthy:
            return 151...200
        case .veryUnhealthy:
            return 201...300
        case .hazardous:
            return 301...500
        }
    }
}

extension AQILevel: CaseIterable {
    static var colors: [Color] {
        allCases.map(\.color)
    }
}

extension AQILevel {
    var name: String {
        switch self {
        case .good:
            return Localizables.aqiLevelTitleGood
        case .moderate:
            return Localizables.aqiLevelTitleModerate
        case .sensitive:
            return Localizables.aqiLevelTitleSensitive
        case .unhealthy:
            return Localizables.aqiLevelTitleUnhealthy
        case .veryUnhealthy:
            return Localizables.aqiLevelTitleVeryUnhealthy
        case .hazardous:
            return Localizables.aqiLevelTitleHazardous
        }
    }
}

extension AQILevel {
    var description: String {
        switch self {
        case .good:
            return Localizables.aqiLevelDescriptionGood
        case .moderate:
            return Localizables.aqiLevelDescriptionModerate
        case .sensitive:
            return Localizables.aqiLevelDescriptionSensitive
        case .unhealthy:
            return Localizables.aqiLevelDescriptionUnhealthy
        case .veryUnhealthy:
            return Localizables.aqiLevelDescriptionVeryUnhealthy
        case .hazardous:
            return Localizables.aqiLevelDescriptionHazardous
        }
    }
}

extension AQILevel {
    var symbol: String {
        switch self {
        case .good:
            return "aqi.low"
        case .moderate, .sensitive:
            return "aqi.medium"
        case .unhealthy, .veryUnhealthy, .hazardous:
            return "aqi.high"
        }
    }
}

extension AQILevel: Identifiable {
    var id: String {
        rawValue
    }
}
