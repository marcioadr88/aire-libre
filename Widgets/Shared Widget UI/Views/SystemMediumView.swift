//
//  SystemMediumView.swift
//  Aire Libre WidgetExtension
//
//  Created by Marcio Duarte on 2023-05-31.
//

import WidgetKit
import SwiftUI

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
            CustomColors.viewBackgroundColor
            
            VStack(alignment: .leading) {
                HStack(alignment: .top, spacing: 24) {
                    if let aqiIndex = entry.aqiIndex {
                        AQIGauge(index: aqiIndex)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Group {
                            Text(entry.location) + (entry.isUserLocation ? Text(" \(Image(systemName: "location.fill"))") : Text(""))
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
            
            if entry.showTimestamp {
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Text(entry.date.formatted(date: .omitted,
                                                  time: .standard))
                        .lineLimit(1)
                        .font(.system(size: 8))
                    }
                }
                .padding()
            }
        }
    }
}

struct SystemMediumView_Previews: PreviewProvider {
    static var previews: some View {
        SystemMediumView(entry: AQIEntry(date: Date(),
                                         source: "29cx2",
                                         location: "Asunción",
                                         aqiIndex: 10,
                                         isUserLocation: true))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
