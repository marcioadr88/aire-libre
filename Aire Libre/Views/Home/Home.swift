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
    
    private var region: Binding<MKCoordinateRegion> {
        Binding {
            viewModel.region
        } set: { region in
            DispatchQueue.main.async {
                viewModel.region = region
            }
        }
    }
    
    init(repository: AireLibreRepository) {
        _viewModel = StateObject(wrappedValue: HomeViewModel(repository: repository))
    }
    
    var body: some View {
        Map(coordinateRegion: region,
            annotationItems: viewModel.aqiData) { item -> MapMarker in
            let coordinate = CLLocationCoordinate2D(latitude: item.latitude,
                                                    longitude: item.longitude)
            
            return MapMarker(coordinate: coordinate)
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
