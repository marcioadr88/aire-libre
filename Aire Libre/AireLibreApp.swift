//
//  Aire_LibreApp.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2022-11-05.
//

import SwiftUI

@main
struct AireLibreApp: App {
    private let repository: AireLibreRepository
    
    init() {
        let connectionChecker = NWPathMonitorConnectionChecker()
        let endpoints = ProductionEndpoints()
        let networkService = NetworkServiceImpl(endpoints: endpoints)
        let persistenceService = PersistenceServiceImpl()
        self.repository = AireLibreRepositoryImpl(networkService: networkService,
                                                  persistenceService: persistenceService,
                                                  connectionChecker: connectionChecker)
    }
    
    var body: some Scene {
        WindowGroup {
            HomeScreen()
                .environmentObject(AppViewModel(repository: repository))
        }
    }
}
