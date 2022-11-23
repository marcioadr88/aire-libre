//
//  AireLibreRepository.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2022-11-22.
//

import Foundation

protocol AireLibreRepository {
    func fetchAQI()
}

final class AireLibreRepositoryImpl: AireLibreRepository {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchAQI() {
        
    }
}
