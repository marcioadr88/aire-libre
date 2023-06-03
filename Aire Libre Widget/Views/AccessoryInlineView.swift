//
//  AccesoryInlineView.swift
//  Aire Libre WidgetExtension
//
//  Created by Marcio Duarte on 2023-06-03.
//

import SwiftUI
import WidgetKit

struct AccessoryInlineView: View {
    var entry: AQIWidgetProvider.Entry
    
    private var aqiLevel: AQILevel? {
        guard let index = entry.aqiIndex else {
            return nil
        }
        
        return AQILevel.fromIndex(index)
    }
    
    var body: some View {
        if let index = entry.aqiIndex, let aqiLevel {
            Group {
                Text("\(Image(systemName: aqiLevel.symbol))") +
                Text(" ") +
                Text(Localizables.aqi) +
                Text(" ") +
                Text("\(index)")
            }
        } else {
            Text("\(Localizables.aqi) --")
        }
    }
}

struct AccesoryInlineView_Previews: PreviewProvider {
    static var previews: some View {
        AccessoryInlineView(entry: AQIEntry(date: Date(),
                                              location: "Asunción",
                                              aqiIndex: 10,
                                              isUserLocation: true))
        .previewContext(WidgetPreviewContext(family: .accessoryInline))
    }
}
