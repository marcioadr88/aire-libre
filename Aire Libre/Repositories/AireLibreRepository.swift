//
//  AireLibreRepository.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2022-11-22.
//

import Foundation

/// The repository fetches data either from network (online) or locally (offline)
protocol AireLibreRepository {
    /// Fetches AQI data from repository
    ///
    /// Fetches Air Quality Index data according to the parameters
    ///
    /// - Parameter source: Include measurements from this source only
    /// - Parameter start: Include measurements after this date and time
    /// - Parameter end: Include measurements before this date and time
    /// - Parameter latitude: Target latitude coordinate
    /// - Parameter longitude: Target longitude coordinate
    /// - Parameter distance: Include measurements that are this kilometers far from the target
    /// - Parameter handler: Function called with the result of the repository call
    func getAQI(
        start: Date?,
        end: Date?,
        latitude: Double?,
        longitude: Double?,
        distance: Double?,
        source: String?) async throws -> [AQIData]
}

final class AireLibreRepositoryImpl: AireLibreRepository {
    private let networkService: NetworkService
    private let connectionChecker: ConnectionChecker
    
    init(networkService: NetworkService,
         connectionChecker: ConnectionChecker) {
        self.networkService = networkService
        self.connectionChecker = connectionChecker
    }
    
    func getAQI(
        start: Date?,
        end: Date?,
        latitude: Double?,
        longitude: Double?,
        distance: Double?,
        source: String?
    ) async throws -> [AQIData] {
        // check for an active connection
        guard connectionChecker.isConnected else {
            throw AppError.noConnection
        }
        
        // we have a connection, then hit the network
        return try await networkService.fetchAQI(start: start,
                                                 end: end,
                                                 latitude: latitude,
                                                 longitude: longitude,
                                                 distance: distance,
                                                 source: source)
    }
}
