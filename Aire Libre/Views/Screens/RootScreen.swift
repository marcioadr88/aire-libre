//
//  Home.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2022-11-05.
//

import SwiftUI
import MapKit

enum Screens: Hashable, Codable {
    case list
    case map(source: String?)
}

struct RootScreen: View {
    @State private var selectedSensor: AQIData?
    @StateObject private var pathStore = NavigationPathStore()
    
    @EnvironmentObject private var appViewModel: AppViewModel
    @EnvironmentObject private var mapScreenViewModel: MapScreenViewModel
    @EnvironmentObject private var locationViewModel: LocationViewModel
    
    var body: some View {
        navigationView
            .onAppear {
                appViewModel.loadAQI()
            }
            .onAppear {
                locationViewModel.startUpdatingLocation()
            }
            .onChange(of: locationViewModel.location) { newValue in
                appViewModel.userLocation = newValue
                mapScreenViewModel.location = newValue
            }
    }
    
    @ViewBuilder
    private var navigationView: some View {
#if os(macOS)
        largeScreenNavigation
#else
        if UIDevice.current.userInterfaceIdiom == .phone {
            smallScreenNavigation
        } else {
            largeScreenNavigation
        }
#endif
    }
    
    @ViewBuilder
    private var smallScreenNavigation: some View {
        NavigationStack(path: $pathStore.path) {
            ListScreen()
        }
    }
    
    @ViewBuilder
    private var largeScreenNavigation: some View {
        NavigationSplitView {
            ListScreen(selectedSensor: $selectedSensor)
                .navigationSplitViewColumnWidth(ideal: 560)
        } detail: {
            MapScreen(selectedSourceId: selectedSensor?.source)
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        RootScreen()
    }
}
