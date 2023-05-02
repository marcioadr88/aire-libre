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
    @Binding private var selectedSensor: AQIData?
    
    init() {
        _selectedSensor = .constant(nil)
    }
    
    init(selectedSensor: Binding<AQIData?>) {
        _selectedSensor = selectedSensor
    }
    
    var body: some View {
        favoritesView
            .navigationTitle("Aire Libre")
            .navigationDestination(for: Screens.self) { screen in
                switch screen {
                case .map(let source):
                    MapScreen(selectedSourceId: source)
                case .list:
                    ListScreen()
                }
            }
            #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                if UIDevice.current.userInterfaceIdiom == .phone {
                    ToolbarItem {
                        NavigationLink(value: Screens.map(source: nil)) {
                            Text(Localizables.viewMap)
                        }
                    }
                }
                
                if appViewModel.isLoading {
                    ToolbarItem(placement: .status) {
                        Text(Localizables.loading)
                    }
                }
            }
            #endif
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
            Text(Localizables.noFavorites)
        }
    }
    
    @ViewBuilder
    private var populatedFavoritesView: some View {
        List(selection: $selectedSensor) {
            ForEach(appViewModel.favorites, id: \.self) { data in
                sensorInfo(for: data)
                    .deleteDisabled(data.isNearestToUser)
            }
            .onDelete { offsets in
                offsets.forEach { index in
                    let aqi = appViewModel.favorites[index]
                    appViewModel
                        .update(newValue: aqi.copy(isFavoriteSensor: false))
                }
            }
        }
        .refreshable {
            appViewModel.loadAQI()
        }
        #if os(macOS)
        .onDeleteCommand(perform: {
            if let selectedSensor, !selectedSensor.isNearestToUser {
                appViewModel.update(newValue: selectedSensor.copy(isFavoriteSensor: false))
            }
        })
        #endif
    }
    
    @ViewBuilder
    private func sensorInfo(for data: AQIData) -> some View {
        let title = data.isNearestToUser ? Localizables.myLocation : data.description
        let subtitle = data.isNearestToUser ? data.description : nil
        
        #if os(macOS)
        SensorInfo(title: title,
                   subtitle: subtitle,
                   aqiIndex: data.quality.index,
                   favorited: .constant(data.isFavoriteSensor),
                   showFavoriteIcon: false)
        #else
        if UIDevice.current.userInterfaceIdiom == .phone {
            NavigationLink(value: Screens.map(source: data.source)) {
                SensorInfo(title: title,
                           subtitle: subtitle,
                           aqiIndex: data.quality.index,
                           favorited: .constant(data.isFavoriteSensor),
                           showFavoriteIcon: false)
            }
        } else {
            SensorInfo(title: title,
                       subtitle: subtitle,
                       aqiIndex: data.quality.index,
                       favorited: .constant(data.isFavoriteSensor),
                       showFavoriteIcon: false)
        }
        #endif
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
