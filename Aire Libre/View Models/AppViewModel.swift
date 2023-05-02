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
    
    @Published var error: AppError?
    @Published var isLoading: Bool
    
    @Published var userLocation: CLLocation? {
        didSet {
            updateNearestSensorToUser()
        }
    }
    
    @Published var nearestSensorToUser: AQIData?
    
    var favorites: [AQIData] {
        let favorites = aqiData.filter { $0.isFavoriteSensor }
        
        if let nearestSensorToUser {
            return [nearestSensorToUser.copy(isNearestToUser: true)] + favorites
        } else {
            return favorites
        }
    }
    
    private let minutesAgo: Int = 60
    private let repository: AireLibreRepository
    
    private var subscriptions = [AnyCancellable]()
    
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
                guard let startDate = dateMinutesAgoFromNow(minutesAgo: minutesAgo) else {
                    log.error("Cannot calculate \(self.minutesAgo) minutes ago from now")
                    throw AppError.unexpected(message: Localizables.cantCalculateStart)
                }
                
                let data = try await repository.getAQI(start: startDate,
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
    
    private func updateNearestSensorToUser() {
        if let userLocation {
            nearestSensorToUser = nearestSensorToUser(userLocation, data: aqiData)
        } else {
            nearestSensorToUser = nil
        }
    }
    
    private func nearestSensorToUser(_ location: CLLocation,
                                     data: [AQIData]) -> AQIData? {
        var nearestSensor: AQIData?
        var smallestDistance = CLLocationDistanceMax
        
        for sensor in data {
            let sensorLocation = CLLocation(latitude: sensor.latitude,
                                            longitude: sensor.longitude)
            let distance = location.distance(from: sensorLocation)
            if distance < smallestDistance {
                smallestDistance = distance
                nearestSensor = sensor
            }
        }
        
        return nearestSensor
    }
    
    private func dateMinutesAgoFromNow(minutesAgo value: Int) -> Date? {
        Calendar.current.date(byAdding: .minute, value: -value, to: Date.now)
    }
}
