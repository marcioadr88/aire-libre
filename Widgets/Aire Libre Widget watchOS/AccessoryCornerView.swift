//
//  AccessoryCornerView.swift
//  Aire Libre Widget watchOS
//
//  Created by Marcio Duarte on 2023-06-20.
//

import SwiftUI
import WidgetKit

struct AccessoryCornerView: View {
    var entry: AQIWidgetProvider.Entry
    
    private let gradient = Gradient(colors: AQILevel.colors)
    private let aqiIndexRange = Double(AQILevel.minAQIIndex)...Double(AQILevel.maxAQIIndex)
    
    private var aqiLevel: AQILevel? {
        guard let index = entry.aqiIndex else {
            return nil
        }
        
        return AQILevel.fromIndex(index)
    }
    
    private var value: Double {
        if let index = entry.aqiIndex {
            return Double(index)
        } else {
            return 0.0
        }
    }
    
    var title: String {
        if entry.aqiIndex == nil {
            return "--"
        } else {
            return entry.location
        }
    }
    
    var body: some View {
        Image(systemName: "\(aqiLevel?.symbol ?? "aqi.low")")
            .font(.system(size: 24, weight: .semibold, design: .rounded))
            .foregroundColor(aqiLevel?.color)
            .widgetLabel {
                if let index = entry.aqiIndex {
                    Group {
                        Text(Localizables.aqi) +
                        Text(" ") +
                        Text("\(index)")
                    }
                    .foregroundColor(aqiLevel?.color)
                } else {
                    Text("\(Localizables.aqi) --")
                }
            }
    }
    
    @ViewBuilder
    private var valueLabel: some View {
        if let index = entry.aqiIndex {
            Text(index, format: .number)
        } else {
            Text("--")
        }
    }
}

struct AccessoryCornerView_Previews: PreviewProvider {
    static var previews: some View {
        AccessoryCornerView(entry: AQIEntry(date: Date(),
                                            source: "29cx2",
                                            location: "Asunción",
                                            aqiIndex: 300,
                                            isUserLocation: true))
        .previewContext(WidgetPreviewContext(family: .accessoryCorner))
    }
}
