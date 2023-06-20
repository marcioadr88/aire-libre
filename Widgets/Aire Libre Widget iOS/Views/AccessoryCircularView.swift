//
//  AccessoryCircularView.swift
//  Aire Libre WidgetExtension
//
//  Created by Marcio Duarte on 2023-06-01.
//

import SwiftUI
import WidgetKit

struct AccessoryCircularView: View {
    var entry: AQIWidgetProvider.Entry
    
    var body: some View {
        ZStack {
            if let index = entry.aqiIndex {
                AQIGauge(index: index)
            } else {
                AQIGauge()
            }
        }
    }
}

struct AccessoryCircularView_Previews: PreviewProvider {
    static var previews: some View {
        AccessoryCircularView(entry: AQIEntry(date: Date(),
                                              source: "29cx2",
                                              location: "Asunción",
                                              aqiIndex: 10,
                                              isUserLocation: true))
        .previewContext(WidgetPreviewContext(family: .accessoryCircular))
    }
}
