//
//  Home.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2022-11-05.
//

import SwiftUI
import MapKit

struct Home: View {
    @StateObject private var viewModel: HomeViewModel
    
    init(repository: AireLibreRepository) {
        _viewModel = StateObject(wrappedValue: HomeViewModel(repository: repository))
    }
    
    var body: some View {
        Map(
            coordinateRegion: .constant(viewModel.region),
            showsUserLocation: true,
            userTrackingMode: .constant(.follow),
            annotationItems: viewModel.aqiData
        ) { item in
            MapAnnotation(coordinate: item.coordinates) {
                AQIAnnotationView(aqiData: item)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            viewModel.loadAQI()
        }
    }
}

#if DEBUG
struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home(repository: Samples.successfulAireLibreRepository)
    }
}
#endif
