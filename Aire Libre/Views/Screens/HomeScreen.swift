//
//  Home.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2022-11-05.
//

import SwiftUI
import MapKit

enum Screens: Hashable {
    case list
    case map(source: String?)
}

struct HomeScreen: View {
    @State private var path = NavigationPath()
    @State private var selectedSensor: AQIData?
    
    @EnvironmentObject private var appViewModel: AppViewModel
    
    var body: some View {
        navigationView
            .onAppear {
                path.append(Screens.map(source: nil))
                
                appViewModel.loadAQI()
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
        NavigationStack(path: $path) {
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
        HomeScreen()
    }
}
