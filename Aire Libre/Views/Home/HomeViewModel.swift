//
//  HomeViewModel.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2022-11-29.
//

import Foundation
import Combine
import MapKit

final class HomeViewModel: ObservableObject {
    @Published var region = MKCoordinateRegion(center: AppConstants.asuncionCoordinates,
                                               span: AppConstants.defaultSpan)
    @Published var aqiData: [AQIData]
    @Published var error: AppError?
    
    private let repository: AireLibreRepository
    
    init(repository: AireLibreRepository) {
        self.repository = repository
        self.aqiData = []
    }
    
    func loadAQI() {
        Task(priority: .background) {
            do {
                let data = try await repository.getAQI(start: Date.now,
                                                       end: nil,
                                                       latitude: region.center.latitude,
                                                       longitude: region.center.longitude,
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
}
