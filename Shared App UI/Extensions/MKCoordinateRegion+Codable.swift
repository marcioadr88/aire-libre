//
//  MKCoordinateRegion+Codable.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2023-04-20.
//

import MapKit

extension MKCoordinateRegion: Codable {
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
        case latitudeDelta
        case longitudeDelta
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let latitude = try values.decode(Double.self, forKey: .latitude)
        let longitude = try values.decode(Double.self, forKey: .longitude)
        let latitudeDelta = try values.decode(Double.self, forKey: .latitudeDelta)
        let longitudeDelta = try values.decode(Double.self, forKey: .longitudeDelta)
        
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
        
        self.init(center: center, span: span)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(center.latitude, forKey: .latitude)
        try container.encode(center.longitude, forKey: .longitude)
        try container.encode(span.latitudeDelta, forKey: .latitudeDelta)
        try container.encode(span.longitudeDelta, forKey: .longitudeDelta)
    }
}
