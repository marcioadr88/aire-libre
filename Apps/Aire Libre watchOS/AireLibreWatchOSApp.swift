//
//  AireLibreWatchOSApp.swift
//  Aire Libre watchOS
//
//  Created by Marcio Duarte on 2023-06-18.
//

import SwiftUI

@main
struct AireLibreWatchOSApp: App {
    private let repository: AireLibreRepository
    
    private let appViewModel: AppViewModel
    private let locationViewModel: LocationViewModel
    
    init() {
        let endpoints = ProductionEndpoints()
        let connectionChecker = HttpConnectionChecker(endpoints: endpoints)
        let networkService = NetworkServiceImpl(endpoints: endpoints)
        let persistenceService = PersistenceServiceImpl()
        self.repository = AireLibreRepositoryImpl(networkService: networkService,
                                                  persistenceService: persistenceService,
                                                  connectionChecker: connectionChecker)
        
        self.appViewModel = AppViewModel(repository: repository)
        self.locationViewModel = LocationViewModel()
    }
    
    var body: some Scene {
        WindowGroup {
            RootScreen()
                .environmentObject(appViewModel)
                .environmentObject(locationViewModel)
        }
    }
}

