//
//  AppViewModel.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2023-01-17.
//

import Foundation
import Combine
import OSLog

final class AppViewModel: ObservableObject {
    private let log = Logger(subsystem: "appvm.re.airelib.ios",
                             category: "AppViewModel")
    
    @Published var aqiData: [AQIData]
    @Published var error: AppError?
 
    private let minutesAgo: Int = 60
    private let repository: AireLibreRepository
    
    private var subscriptions = [AnyCancellable]()
    
    init(repository: AireLibreRepository) {
        self.repository = repository
        self.aqiData = []
    }

    func update(newValue: AQIData) {
        // find index to update and check it's distinct from newValue
        guard let index = aqiData.firstIndex(where: { $0.source == newValue.source }),
              aqiData[index] != newValue else {
            return
        }

        log.debug("Updating data of \(newValue.source) at index \(index)")
        
        aqiData[index] = newValue
    }
    
    func loadAQI() {
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
                    aqiData = data
                }
            } catch {
                await MainActor.run {
                    self.error = AppError.fromError(error)
                }
            }
        }
    }
    
    private func dateMinutesAgoFromNow(minutesAgo value: Int) -> Date? {
        Calendar.current.date(byAdding: .minute, value: -value, to: Date.now)
    }
}
