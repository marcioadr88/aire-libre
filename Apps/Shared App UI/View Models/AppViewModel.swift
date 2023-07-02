//
//  AppViewModel.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2023-01-17.
//

import Foundation
import Combine
import OSLog
import CoreLocation

final class AppViewModel: NSObject, ObservableObject {
    private let log = Logger(subsystem: "appvm.re.airelib.ios",
                             category: String(describing: AppViewModel.self))
    
    @Published var aqiData: [AQIData] {
        didSet {
            updateNearestSensorToUser()
        }
    }
    
    var aqiDataOrderedByDistance: [AQIData] {
        orderByDistance(data: aqiData)
    }
    
    @Published var error: AppError?
    @Published var isLoading: Bool
    
    var hasError: Bool {
        get {
            error != nil
        }
        set {
            if !newValue {
                error = nil
            }
        }
    }
    
    @Published var userLocation: CLLocation? {
        didSet {
            updateNearestSensorToUser()
        }
    }
    
    @Published var nearestSensorToUser: AQIData?
    
    var favorites: [AQIData] {
        var favorites = aqiData.filter { $0.isFavoriteSensor }
        favorites = orderByDistance(data: favorites)
        
        if let nearestSensorToUser {
            return [nearestSensorToUser.copy(isNearestToUser: true)] + favorites
        } else {
            return favorites
        }
    }
    
    private let repository: AireLibreRepository
    
    init(repository: AireLibreRepository) {
        self.repository = repository
        self.aqiData = []
        self.isLoading = false
    }
    
    func update(newValue: AQIData) {
        // find index to update and check it's distinct from newValue
        guard let index = aqiData.firstIndex(where: { $0.source == newValue.source }),
              aqiData[index] != newValue else {
            return
        }
        
        log.debug("Updating data of \(newValue.source) at index \(index)")
        
        Task {
            do {
                if newValue.isFavoriteSensor {
                    try await repository.saveFavorite(source: newValue.source)
                } else {
                    try await repository.deleteFavorite(source: newValue.source)
                }
                
                await MainActor.run {
                    self.aqiData[index] = newValue
                }
            } catch {
                log.error("Error while updating favorite \(error.localizedDescription)")
            }
        }
    }
    
    func loadAQI() {
        isLoading = true
        
        Task(priority: .background) {
            do {
                let data = try await repository.getAQI(minutesAgo: AppConstants.defaultMinutesAgo,
                                                       end: nil,
                                                       latitude: nil,
                                                       longitude: nil,
                                                       distance: nil,
                                                       source: nil)
                await MainActor.run {
                    self.aqiData = data
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.error = AppError.fromError(error)
                    self.isLoading = false
                }
            }
        }
    }
    
    func aqiData(withSource source: String) -> AQIData? {
        aqiData
            .first(where: { $0.source == source })
    }
    
    private func updateNearestSensorToUser() {
        if let userLocation {
            nearestSensorToUser = LocationUtils.nearestSensorToUser(userLocation,
                                                                    data: aqiData)
        } else {
            nearestSensorToUser = nil
        }
    }
    
    private func orderByDistance(data: [AQIData]) -> [AQIData] {
        guard let userLocation else { return data }
        
        return LocationUtils.sortByDistance(data: data, to: userLocation)
    }
}
