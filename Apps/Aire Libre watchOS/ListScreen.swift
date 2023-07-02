//
//  ListScreen.swift
//  Aire Libre watchOS
//
//  Created by Marcio Duarte on 2023-06-18.
//

import SwiftUI

struct ListScreen: View {
    @EnvironmentObject private var appViewModel: AppViewModel
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle(Localizables.appName)
                .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    @ViewBuilder
    private var content: some View {
        if appViewModel.isLoading {
            Text(Localizables.loading)
        } else if appViewModel.aqiData.isEmpty {
            Text(Localizables.noData)
        } else {
            list
        }
    }
    
    @ViewBuilder
    private var list: some View {
        List {
            ForEach(appViewModel.aqiDataOrderedByDistance) { data in
                SensorInfo(title: data.description,
                           aqiIndex: data.quality.index)
            }
        }
        .refreshable {
            appViewModel.loadAQI()
        }
    }
}

struct ListScreen_Previews: PreviewProvider {
    static var previews: some View {
        ListScreen()
    }
}
