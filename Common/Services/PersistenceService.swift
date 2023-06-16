//
//  PersistenceService.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2023-04-15.
//

import Foundation
import OSLog

protocol PersistenceService: FavoritesPersistenceServices {}

protocol FavoritesPersistenceServices {
    func loadFavorites() async throws -> [String]
    func saveFavorite(source: String) async throws
    func deleteFavorite(source: String) async throws
}

final class PersistenceServiceImpl: PersistenceService {
    private let log = Logger(subsystem: "persistence.re.airelib.ios",
                             category: String(describing: PersistenceServiceImpl.self))
    
    private var favoritesStoreInstace: FavoriteSensorStore?
}

extension PersistenceServiceImpl: FavoritesPersistenceServices {
    private var favoritesStore: FavoriteSensorStore {
        get async {
            if let favoritesStoreInstace {
                return favoritesStoreInstace
            }
            
            var newFavoriteStore: FavoriteSensorStore

            do {
                newFavoriteStore = try await PersistentFavoriteSensorStore()
                log.info("Using CoreData favorite store")
            } catch {
                log.error("Could not init CoreData persistence store \(error.localizedDescription)")
                newFavoriteStore = InMemoryFavoriteSensorStore()
                log.info("Using in memory favorite store")
            }

            favoritesStoreInstace = newFavoriteStore
            
            return newFavoriteStore
        }
    }
    
    func loadFavorites() async throws -> [String] {
        log.info("Loading favorites")
        let favorites = try await favoritesStore.read()
        
        log.debug("\(favorites.count) favorites loaded")
        
        return favorites
    }
    
    func saveFavorite(source: String) async throws {
        log.info("Saving favorite with source \(source)")
        try await favoritesStore.create(source: source)
    }
    
    func deleteFavorite(source: String) async throws {
        log.info("Deleting favorite with source \(source)")
        try await favoritesStore.delete(source: source)
    }
}
