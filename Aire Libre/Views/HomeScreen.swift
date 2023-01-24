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
    case map
}

struct HomeScreen: View {
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            ListScreen()
                .navigationDestination(for: Screens.self) { screen in
                    switch screen {
                    case .map:
                        MapScreen()
                    case .list:
                        ListScreen()
                    }
                }
        }
        .onAppear {
            path.append(Screens.map)
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
