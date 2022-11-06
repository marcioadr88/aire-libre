//
//  MeasurementData.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2022-11-06.
//

import Foundation

struct MeasurementData: Codable {
    let sensor, source, description, version: String
    let pm1dot0, pm2dot5, pm10: Int
    let longitude, latitude: Double
    let recorded: Date

    enum CodingKeys: String, CodingKey {
        case sensor
        case source
        case description
        case version
        case pm1dot0
        case pm2dot5
        case pm10
        case longitude
        case latitude
        case recorded
    }
}
