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
    
    private let repository: AireLibreRepository
    
    init(repository: AireLibreRepository) {
        self.repository = repository
        self.aqiData = []
    }
    
    func loadAQI() {
        repository.getAQI(start: Date.now,
                          end: nil,
                          latitude: region.center.latitude,
                          longitude: region.center.longitude,
                          distance: nil,
                          source: nil) { result in
            Task {
                await MainActor.run {
                    switch result {
                    case .success(let data):
                        self.aqiData = data
                    case .failure:
                        break
                    }
                }
            }
        }
    }
}
