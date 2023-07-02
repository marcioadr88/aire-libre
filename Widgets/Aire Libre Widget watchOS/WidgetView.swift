//
//  WidgetView.swift
//  Aire Libre Widget watchOS
//
//  Created by Marcio Duarte on 2023-06-20.
//

import WidgetKit
import SwiftUI

struct WidgetView: View {
    @Environment(\.widgetFamily) var widgetFamily
    
    var entry: AQIWidgetProvider.Entry

    var body: some View {
        if entry.isError {
            errorWidget(for: entry)
        } else {
            widget(for: entry)
        }
    }
    
    @ViewBuilder
    private func widget(for entry: AQIWidgetProvider.Entry) -> some View {
        switch widgetFamily {
        case .accessoryCorner:
            AccessoryCornerView(entry: entry)
        case .accessoryRectangular:
            AccessoryRectangularView(entry: entry)
        case .accessoryCircular:
            AccessoryCircularView(entry: entry)
        case .accessoryInline:
            AccessoryInlineView(entry: entry)
        default:
            ErrorWidgetView(message: Localizables.widgetFamilyNotSupported)
        }
    }
    
    @ViewBuilder
    private func errorWidget(for entry: AQIWidgetProvider.Entry) -> some View {
        if let error = entry.error {
            switch error {
            case .recoverable(let message):
                ErrorWidgetView(message: message)
            case .fatal(let message):
                ErrorWidgetView(message: message)
            }
        }
    }
}

struct WidgetPreviews: PreviewProvider {
    static var previews: some View {
        WidgetView(entry: AQIEntry(date: Date(),
                                   source: "29cx2",
                                   location: "Asunción",
                                   aqiIndex: 10,
                                   isUserLocation: true))
        .previewContext(WidgetPreviewContext(family: .accessoryCircular))
    }
}
