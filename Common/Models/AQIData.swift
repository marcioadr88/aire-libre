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
    var isNearestToUser: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case sensor
        case source
        case description
        case longitude
        case latitude
        case quality
    }
}

extension AQIData {
    func copy(sensor: String? = nil,
              source: String? = nil,
              description: String? = nil,
              longitude: Double? = nil,
              latitude: Double? = nil,
              quality: Quality? = nil,
              isFavoriteSensor: Bool? = nil,
              isNearestToUser: Bool? = nil) -> AQIData {
        return AQIData(sensor: sensor ?? self.sensor,
                       source: source ?? self.source,
                       description: description ?? self.description,
                       longitude: longitude ?? self.longitude,
                       latitude: latitude ?? self.latitude,
                       quality: quality ?? self.quality.copy(),
                       isFavoriteSensor: isFavoriteSensor ?? self.isFavoriteSensor,
                       isNearestToUser: isNearestToUser ?? self.isNearestToUser)
    }
}
