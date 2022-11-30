//
//  NetworkServiceConstants.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2022-11-22.
//

import Foundation

protocol NetworkServiceEndpoints {
    var aqiEndpoint: URL { get }
    var measurementEndpoint: URL { get }
}

final class ProductionEndpoints: NetworkServiceEndpoints {
    private let baseUrl = URL(string: "https://rald-dev.greenbeep.com/api/v1")!
    
    var aqiEndpoint: URL {
        baseUrl.appendingPathComponent("aqi")
    }
    
    var measurementEndpoint: URL {
        baseUrl.appendingPathComponent("measurements")
    }
}
