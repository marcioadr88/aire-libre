//
//  ErrorWidgetView.swift
//  Aire Libre WidgetExtension
//
//  Created by Marcio Duarte on 2023-05-31.
//

import SwiftUI
import WidgetKit

struct ErrorWidgetView: View {
    @Environment(\.widgetFamily) var widgetFamily
    
    var date: Date
    var message: String
    
    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            SmallErrorWidgetView(date: date,
                                 message: message)
        case .systemMedium:
            MediumErrorWidgetView(date: date,
                                  message: message)
            
        default:
            FatalErrorWidgetView(message: Localizables.widgetFamilyNotSupported)
        }
    }
}

struct SmallErrorWidgetView: View {
    var date: Date
    var message: String
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
            
            VStack(alignment: .center, spacing: 6) {
                AQIGauge()
                
                Text(message)
                    .lineLimit(3)
                    .minimumScaleFactor(0.5)
                    .font(.subheadline)
                
                Text(date.formatted(date: .omitted,
                                          time: .standard))
                .lineLimit(1)
                .font(.system(size: 8))
            }
            .multilineTextAlignment(.center)
            .padding()
        }
    }
}


struct MediumErrorWidgetView: View {
    var date: Date
    var message: String
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
            
            VStack {
                HStack(alignment: .center, spacing: 24) {
                    AQIGauge()
                    
                    Text(message)
                        .lineLimit(5)
                        .minimumScaleFactor(0.5)
                        .font(.subheadline)
                    
                    Spacer()
                }
            }
            .padding()
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Text(date.formatted(date: .omitted,
                                              time: .standard))
                        .lineLimit(1)
                        .font(.system(size: 8))
                }
            }
            .padding()
        }
    }
}

struct ErrorWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorWidgetView(date: Date(), message: "Error")
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
