//
//  ListView.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2023-01-20.
//

import SwiftUI

struct ListScreen: View {
    @EnvironmentObject private var appViewModel: AppViewModel

    var body: some View {
        List(appViewModel.aqiData, id: \.self) { data in
            NavigationLink(value: Screens.map(source: data.source)) {
                SensorInfo(aqiData: data)
            }
        }
        .navigationTitle("Aire Libre")
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
