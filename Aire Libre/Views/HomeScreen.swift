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
        NavigationStack(path: $path) {
            ListScreen()
                .navigationDestination(for: Screens.self) { screen in
                    switch screen {
                    case .map(let source):
                        MapScreen(selectedSourceId: source)
                    case .list:
                        ListScreen()
                    }
                }
        }
        .onAppear {
            path.append(Screens.map(source: nil))
            
            appViewModel.loadAQI()
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
