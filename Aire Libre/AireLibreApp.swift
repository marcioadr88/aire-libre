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
    
    private let appViewModel: AppViewModel
    private let mapScreenViewModel: MapScreenViewModel
    private let locationViewModel: LocationViewModel
    
    init() {
        let connectionChecker = NWPathMonitorConnectionChecker()
        let endpoints = ProductionEndpoints()
        let networkService = NetworkServiceImpl(endpoints: endpoints)
        let persistenceService = PersistenceServiceImpl()
        self.repository = AireLibreRepositoryImpl(networkService: networkService,
                                                  persistenceService: persistenceService,
                                                  connectionChecker: connectionChecker)
        
        self.appViewModel = AppViewModel(repository: repository)
        self.mapScreenViewModel = MapScreenViewModel()
        self.locationViewModel = LocationViewModel()
    }
    
    var body: some Scene {
        WindowGroup {
            RootScreen()
                .environmentObject(appViewModel)
                .environmentObject(mapScreenViewModel)
                .environmentObject(locationViewModel)
        }
    }
}
