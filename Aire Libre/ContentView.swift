//
//  ContentView.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2022-11-05.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var region = MKCoordinateRegion(center: AppConstants.asuncionCoordinates,
                                                   span: AppConstants.defaultSpan)

    
    var body: some View {
        Map(coordinateRegion: $region)
            .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
