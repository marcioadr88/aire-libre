//
//  WidgetView.swift
//  Aire Libre WidgetExtension
//
//  Created by Marcio Duarte on 2023-05-03.
//

import WidgetKit
import SwiftUI

struct WidgetView: View {
    @Environment(\.widgetFamily) var widgetFamily
    
    var entry: AQIWidgetProvider.Entry
    
    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            SystemSmallView(entry: entry)
        case .systemMedium:
            SystemMediumView(entry: entry)
        default:
            Text("Not Supported")
        }
    }
}

struct SystemSmallView: View {
    var entry: AQIWidgetProvider.Entry
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
            
            VStack(alignment: .center, spacing: 4) {
                Group {
                    Text(entry.location) + (entry.isUserLocation ? Text(" \(Image(systemName: "location"))") : Text(""))
                }
                .lineLimit(1)
                .minimumScaleFactor(0.9)
                .font(.caption2)
                
                AQIGauge(index: entry.aqiIndex)
                
                Text(entry.levelName ?? "")
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)
                    .font(.headline)
            }
            .multilineTextAlignment(.center)
            .padding()
        }
    }
}

struct SystemMediumView: View {
    var entry: AQIWidgetProvider.Entry
    
    private var locationText: String {
        var text = entry.location
        
        if entry.isUserLocation {
            text.append(" \(Image(systemName: "location.fill"))")
        }
        
        return text
    }
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
            
            VStack(alignment: .leading) {
                HStack(alignment: .top, spacing: 24) {
                    AQIGauge(index: entry.aqiIndex)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Group {
                            Text(entry.location) + (entry.isUserLocation ? Text(" \(Image(systemName: "location"))") : Text(""))
                        }
                        .lineLimit(1)
                        .minimumScaleFactor(0.9)
                        .font(.caption)
                        
                        Text(entry.levelName ?? "")
                            .lineLimit(2)
                            .minimumScaleFactor(0.5)
                            .font(.title3.weight(.medium))
                    }
                    
                    Spacer()
                }
                
                Text(entry.levelDescription ?? "")
                    .font(.caption2)
            }
            .padding()
        }
    }
}

struct WidgetPreviews: PreviewProvider {
    static var previews: some View {
        WidgetView(entry: AQIEntry(date: Date(),
                                   location: "Asunción",
                                   aqiIndex: 10,
                                   isUserLocation: true))
        .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
