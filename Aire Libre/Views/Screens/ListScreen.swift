//
//  ListView.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2023-01-20.
//

import SwiftUI
import Combine

struct ListScreen: View {
    @EnvironmentObject private var appViewModel: AppViewModel
    
    var body: some View {
        favoritesView
            .navigationTitle(Localizables.favorites)
            .navigationDestination(for: Screens.self) { screen in
                switch screen {
                case .map(let source):
                    MapScreen(selectedSourceId: source)
                case .list:
                    ListScreen()
                }
            }
    }
    
    @ViewBuilder
    private var favoritesView: some View {
        if appViewModel.favorites.isEmpty {
            emptyFavoritesView
        } else {
            populatedFavoritesView
        }
    }
    
    @ViewBuilder
    private var emptyFavoritesView: some View {
        VStack(spacing: 8) {
            Text("No hay favoritos")
            
            #if !os(macOS)
            NavigationLink(value: Screens.map(source: nil)) {
                Text("Ver mapa")
            }
            #endif
        }
    }
    
    @ViewBuilder
    private var populatedFavoritesView: some View {
        List(appViewModel.favorites) { data in
            NavigationLink(value: Screens.map(source: data.source)) {
                SensorInfo(sensorName: data.description,
                           aqiIndex: data.quality.index,
                           favorited: Binding<Bool>(get: {
                    data.isFavoriteSensor
                }, set: { value in
                    appViewModel
                        .update(newValue: data.copy(isFavoriteSensor: value))
                }))
            }
        }
    }
}

struct ListScreen_Previews: PreviewProvider {
    static var previews: some View {
        ListScreen()
            .environmentObject(Samples.appViewModel)
            .onAppear {
                Samples.appViewModel.loadAQI()
            }
    }
}
