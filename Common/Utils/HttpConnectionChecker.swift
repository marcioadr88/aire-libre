//
//  HTTPConnectionChecker.swift
//  Aire Libre Widget watchOS
//
//  Created by Marcio Duarte on 2023-06-20.
//

import Foundation
import OSLog

/// An http based connection checker for devices with unsopported NWPathMonitor
final class HttpConnectionChecker: ConnectionChecker {
    private let log = Logger(subsystem: AppConstants.bundleId,
                             category: String(describing: HttpConnectionChecker.self))
    private let endpoints: NetworkServiceEndpoints
    
    init(endpoints: NetworkServiceEndpoints) {
        self.endpoints = endpoints
    }
    
    var isConnected: Bool {
        get async {
            let url = endpoints.aqiEndpoint
            
            do {
                let (_, response) = try await URLSession.shared.data(from: url)
                
                let statusCode = (response as? HTTPURLResponse)?.statusCode

                log.debug("Connection checker responded with status code \(statusCode.map(String.init) ?? "nil")")
                
                return statusCode == 200
            } catch {
                log.error("Connection checker responded with error")
                return false
            }
        }
    }
}
