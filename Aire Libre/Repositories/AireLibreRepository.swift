//
//  AireLibreRepository.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2022-11-22.
//

import Foundation
import OSLog

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
    
    /// Marks a sensor as favorite
    func saveFavorite(source: String) async throws
    
    /// Deletes a sensor from favorites
    func deleteFavorite(source: String) async throws
}

final class AireLibreRepositoryImpl: AireLibreRepository {
    private let log = Logger(subsystem: "repository.re.airelib.ios",
                             category: "AireLibreRepositoryImpl")
    
    private let networkService: NetworkService
    private let connectionChecker: ConnectionChecker
    private let persistenceService: PersistenceService
    
    init(networkService: NetworkService,
         persistenceService: PersistenceService,
         connectionChecker: ConnectionChecker) {
        self.networkService = networkService
        self.connectionChecker = connectionChecker
        self.persistenceService = persistenceService
    }
    
    func getAQI(
        start: Date?,
        end: Date?,
        latitude: Double?,
        longitude: Double?,
        distance: Double?,
        source: String?
    ) async throws -> [AQIData] {
        try await Task<[AQIData], Error>.retrying { [weak self] in
            guard let self else {
                throw AppError.unexpected(message: nil)
            }
            
            let rawData = try await self.checkNetworkAndFetchAQI(start: start,
                                                                 end: end,
                                                                 latitude: latitude,
                                                                 longitude: longitude,
                                                                 distance: distance,
                                                                 source: source)
            
            let favoriteSources = try await self.persistenceService.loadFavorites()
            
            log.debug("Marking favorites")
            return self.markFavorites(in: rawData,
                                      favoritesSources: Set<String>(favoriteSources))
            
        }.value
    }
    
    private func checkNetworkAndFetchAQI(
        start: Date?,
        end: Date?,
        latitude: Double?,
        longitude: Double?,
        distance: Double?,
        source: String?
    ) async throws -> [AQIData] {
        guard connectionChecker.isConnected else {
            log.error("No connection detected")
            throw AppError.noConnection
        }
        
        log.debug("Fetching AQI data using network")
        return try await networkService.fetchAQI(start: start,
                                                 end: end,
                                                 latitude: latitude,
                                                 longitude: longitude,
                                                 distance: distance,
                                                 source: source)
    }
}

// MARK: Favorites handling
extension AireLibreRepositoryImpl {
    func saveFavorite(source: String) async throws {
        try await persistenceService.saveFavorite(source: source)
    }
    
    func deleteFavorite(source: String) async throws {
        try await persistenceService.deleteFavorite(source: source)
    }
    
    private func markFavorites(in data: [AQIData],
                               favoritesSources: Set<String>) -> [AQIData] {
        guard !favoritesSources.isEmpty else {
            return data
        }
        
        return data.map { sensor in
            if favoritesSources.contains(sensor.source) {
                return sensor.copy(isFavoriteSensor: true)
            } else {
                return sensor
            }
        }
    }
}
