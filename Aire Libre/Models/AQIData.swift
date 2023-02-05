//
//  AQIData.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2022-11-06.
//

import Foundation

struct AQIData: Codable, Sendable, Identifiable, Equatable, Hashable {
    var id: String {
        return source
    }
    
    let sensor, source, description: String
    let longitude, latitude: Double
    let quality: Quality
    var isFavoriteSensor: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case sensor
        case source
        case description
        case longitude
        case latitude
        case quality
    }
}
