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
        #if os(iOS)
            smallScreenNavigation
        #else
            largeScreenNavigation
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
            ListScreen()
                .navigationSplitViewColumnWidth(ideal: 300)
        } detail: {
            MapScreen()
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
