//
//  PersistentStore.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2023-04-09.
//

import CoreData
import OSLog

protocol FavoriteSensorStore {
    func read() throws -> [String]
    func create(source: String, description: String) async throws
    func delete(source: String) throws
}

/// Core data persistent store
class PersistentFavoriteSensorStore: FavoriteSensorStore {
    private let log = Logger(subsystem: AppConstants.bundleId,
                             category: String(describing: PersistentFavoriteSensorStore.self))
    
    private let container: NSPersistentContainer
    
    init() async throws {
        container = NSPersistentContainer(name: "Entities")
        
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            container.loadPersistentStores { [weak self] (description, error) in
                if let error  {
                    continuation.resume(throwing: error)
                } else {
                    self?.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
                    continuation.resume()
                }
            }
        }
    }
    
    func create(source: String, description: String) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            container.performBackgroundTask { context in
                let sensor = FavoriteSensor(context: context)
                sensor.source = source
                sensor.name = description
                
                do {
                    try context.save()
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func delete(source: String) throws {
        let fetchRequest: NSFetchRequest<FavoriteSensor> = FavoriteSensor.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "source == %@", source)
        
        let result = try container.viewContext.fetch(fetchRequest)
        
        if let sensor = result.first {
            log.info("Store: sensor to delete \(sensor)")
            container.viewContext.delete(sensor)
            
            do {
                try container.viewContext.save()
            } catch {
                log.error("Error deleting \(source): \(error.localizedDescription)")
                
                throw error
            }
        }
    }
    
    func read() throws -> [String] {
        return try readFavorites().compactMap { $0.source }
    }
    
    private func readFavorites() throws -> [FavoriteSensor] {
        let request: NSFetchRequest<FavoriteSensor> = FavoriteSensor.fetchRequest()
        
        return try container.viewContext.fetch(request)
    }
}

/// Memory sensor store
class InMemoryFavoriteSensorStore: FavoriteSensorStore {
    private var favoriteSources = Set<String>()
    
    func read() throws -> [String] {
        return Array(favoriteSources)
    }
    
    func create(source: String, description: String) async throws {
        favoriteSources.insert(source)
    }
    
    func delete(source: String) throws {
        favoriteSources.remove(source)
    }
}
