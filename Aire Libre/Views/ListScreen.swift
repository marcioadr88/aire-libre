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
    
    @State private var favorites: [AQIData] = []
    
    var body: some View {
        List($favorites) { $data in
            NavigationLink(value: Screens.map(source: data.source)) {
                SensorInfo(sensorName: data.description,
                           aqiIndex: data.quality.index,
                           favorited: $data.isFavoriteSensor)
                .onChange(of: data.isFavoriteSensor) { newValue in
                    appViewModel.update(newValue: data)
                }
            }
        }
        .navigationTitle(Localizables.favorites)
        .onAppear {
            updateFavorites()
        }
    }
    
    private func updateFavorites() {
        favorites = appViewModel.aqiData.filter { $0.isFavoriteSensor }
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
