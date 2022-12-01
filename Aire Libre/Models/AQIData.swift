//
//  AQIData.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2022-11-06.
//

import Foundation

struct AQIData: Codable, Sendable {
    let sensor, source, description: String
    let longitude, latitude: Double
    let quality: Quality

    enum CodingKeys: String, CodingKey {
        case sensor
        case source
        case description
        case longitude
        case latitude
        case quality
    }
}
