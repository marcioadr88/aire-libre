//
//  Samples.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2022-11-29.
//

import Foundation

final class Samples {
    private init() {}
    
    static let aqiData: [AQIData] = JSONFileLoader.loadJsonFileOrFail("sample1")
    static let successfulAireLibreRepository = SuccessfulAireLibreRepository(aqiData: aqiData)
    static let failureAireLibreRepository = FailureAireLibreRepository()
    
    static let appViewModel = AppViewModel(repository: successfulAireLibreRepository)
}

final class SuccessfulAireLibreRepository: AireLibreRepository {
    func saveFavorite(source: String) throws {}
    
    func deleteFavorite(source: String) throws {}
    
    private let aqiData: [AQIData]
    
    init(aqiData: [AQIData]) {
        self.aqiData = aqiData
    }
    
    func getAQI(start: Date?,
                end: Date?,
                latitude: Double?,
                longitude: Double?,
                distance: Double?,
                source: String?) async throws -> [AQIData] {
        return aqiData
    }
}

final class FailureAireLibreRepository: AireLibreRepository {
    func saveFavorite(source: String) throws {}
    
    func deleteFavorite(source: String) throws {}
    
    func getAQI(start: Date?,
                end: Date?,
                latitude: Double?,
                longitude: Double?,
                distance: Double?,
                source: String?) async throws -> [AQIData] {
        throw AppError.noConnection
    }
}
