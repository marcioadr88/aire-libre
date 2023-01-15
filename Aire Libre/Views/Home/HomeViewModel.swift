//
//  HomeViewModel.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2022-11-29.
//

import Foundation
import Combine
import MapKit
import OSLog

final class HomeViewModel: ObservableObject {
    private let log = Logger(subsystem: "home.re.airelib.ios",
                             category: "HomeViewModel")
    
    @Published var region = MKCoordinateRegion(center: AppConstants.asuncionCoordinates,
                                               span: AppConstants.defaultSpan)
    @Published var aqiData: [AQIData]
    @Published var error: AppError?
        
    @Published var selectedData: AQIData? {
        didSet {
            guard let selectedData else {
                return
            }
            
            region = MKCoordinateRegion(center: selectedData.coordinates,
                                        span: region.span)
        }
    }
    
    private let minutesAgo: Int = 60
    private let repository: AireLibreRepository
    
    private var subscriptions = [AnyCancellable]()
    
    init(repository: AireLibreRepository) {
        self.repository = repository
        self.aqiData = []
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
