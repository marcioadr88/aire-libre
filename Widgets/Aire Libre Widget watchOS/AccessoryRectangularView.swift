//
//  AccessoryRectangularView.swift
//  Aire Libre Widget watchOS
//
//  Created by Marcio Duarte on 2023-06-20.
//

import SwiftUI
import WidgetKit

struct AccessoryRectangularView: View {
    var entry: AQIWidgetProvider.Entry
    
    var title: String {
        if entry.aqiIndex == nil {
            return "--"
        } else {
            return entry.location
        }
    }
    
    var body: some View {
        SensorInfo(title: title, aqiIndex: entry.aqiIndex)
    }
}

struct AccessoryRectangularView_Previews: PreviewProvider {
    static var previews: some View {
        AccessoryInlineView(entry: AQIEntry(date: Date(),
                                            source: "29cx2",
                                            location: "Asunción",
                                            aqiIndex: 10,
                                            isUserLocation: true))
        .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
    }
}
