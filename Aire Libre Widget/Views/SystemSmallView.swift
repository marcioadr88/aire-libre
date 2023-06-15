//
//  SystemSmallView.swift
//  Aire Libre WidgetExtension
//
//  Created by Marcio Duarte on 2023-05-31.
//

import WidgetKit
import SwiftUI

struct SystemSmallView: View {
    var entry: AQIWidgetProvider.Entry
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
            
            VStack(alignment: .center, spacing: 4) {
                Group {
                    Text(entry.location) + (entry.isUserLocation ? Text(" \(Image(systemName: "location.fill"))") : Text(""))
                }
                .lineLimit(1)
                .minimumScaleFactor(0.9)
                .font(.caption2)
                
                if let aqiIndex = entry.aqiIndex {
                    AQIGauge(index: aqiIndex)
                }
                
                Text(entry.levelName ?? "")
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)
                    .font(.headline)
                
                if entry.showTimestamp {
                    Text(entry.date.formatted(date: .omitted,
                                              time: .standard))
                    .lineLimit(1)
                    .font(.system(size: 8))
                }
            }
            .multilineTextAlignment(.center)
            .padding()
        }
    }
}

struct SystemSmallView_Previews: PreviewProvider {
    static var previews: some View {
        SystemSmallView(entry: AQIEntry(date: Date(),
                                        source: "29cx2",
                                        location: "Asunción",
                                        aqiIndex: 10,
                                        isUserLocation: true))
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
