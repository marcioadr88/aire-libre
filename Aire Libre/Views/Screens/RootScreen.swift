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
    @Environment(\.scenePhase) var scenePhase
    
    @State private var selectedSensor: AQIData?
    @StateObject private var pathStore = NavigationPathStore()
    
    @EnvironmentObject private var appViewModel: AppViewModel
    @EnvironmentObject private var mapScreenViewModel: MapScreenViewModel
    @EnvironmentObject private var locationViewModel: LocationViewModel
    
    var body: some View {
        navigationView
            .onAppear {
                locationViewModel.startUpdatingLocation()
            }
            .onChange(of: locationViewModel.location) { newValue in
                appViewModel.userLocation = newValue
                mapScreenViewModel.location = newValue
            }
            .onChange(of: scenePhase) { phase in
                if phase == .active {
                    appViewModel.loadAQI()
                }
            }
            .onOpenURL { url in
                if let source = Utils.source(forWidgetOpenURL: url) {
                    print("--> before ")
                    print("--> path \(pathStore.path)")
                    print("--> count \(pathStore.path.count)")
                    
                    if !pathStore.path.isEmpty {
                        pathStore.path.removeLast()
                    }
                    print("--> after delete")
                    print("--> path \(pathStore.path)")
                    print("--> count \(pathStore.path.count)")
                    
                    pathStore.path.append(Screens.map(source: source))
                }
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
