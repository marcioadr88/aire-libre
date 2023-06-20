//
//  RootScreen.swift
//  Aire Libre watchOS
//
//  Created by Marcio Duarte on 2023-06-18.
//

import SwiftUI

struct RootScreen: View {
    @EnvironmentObject private var appViewModel: AppViewModel
    @EnvironmentObject private var locationViewModel: LocationViewModel
    @State private var selectedSensor: AQIData?
    
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        ListScreen()
            .onReceive(locationViewModel.$location) { location in
                appViewModel.userLocation = location
            }
            .onChange(of: scenePhase) { phase in
                switch phase {
                case .active:
                    locationViewModel.startUpdatingLocation()
                    appViewModel.loadAQI()
                case .inactive:
                    locationViewModel.stopUpdatingLocation()
                default:
                    break
                }
            }
            .alert(isPresented: $appViewModel.hasError) {
                Alert(title: Text(Localizables.errorOccurred),
                      message: Text(appViewModel.error?.localizedDescription ?? Localizables.unexpectedError),
                      dismissButton: .default(Text(Localizables.dismiss)))
            }
    }
}

struct RootScreen_Previews: PreviewProvider {
    static var previews: some View {
        RootScreen()
    }
}
