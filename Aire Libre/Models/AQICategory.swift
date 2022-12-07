//
//  AQICategory.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2022-12-05.
//

import Foundation
import SwiftUI

enum AQICategory: String {
    case good
    case moderate
    case sensitive
    case unhealthy
    case veryUnhealthy
    case dangeours
    
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
        case .dangeours:
            return Color(hex: 0x7e0023)
        }
    }
    
    static func fromIndex(_ index: Int) -> AQICategory? {
        switch index {
        case 0...50:
            return .good
        case 51...100:
            return .moderate
        case 101...150:
            return .sensitive
        case 151...200:
            return .unhealthy
        case 201...300:
            return .veryUnhealthy
        case 301...500:
            return .dangeours
        default:
            return nil
        }
    }
}
