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
    
    var widgetURL: URL? {
        guard let source = entry.source else {
            return nil
        }
        
        return Utils.widgetOpenURL(for: source)
    }
    
    var body: some View {
        if let error = entry.error {
            errorWidget(error)
        } else {
            widget(for: entry)
                .widgetURL(widgetURL)
        }
    }
    
    @ViewBuilder
    private func widget(for entry: AQIWidgetProvider.Entry) -> some View {
        switch widgetFamily {
        case .systemSmall:
            SystemSmallView(entry: entry)
        case .systemMedium:
            SystemMediumView(entry: entry)
        case .accessoryCircular:
            AccessoryCircularView(entry: entry)
        case .accessoryInline:
            AccessoryInlineView(entry: entry)
        default:
            FatalErrorWidgetView(message: Localizables.widgetFamilyNotSupported)
        }
    }
    
    @ViewBuilder
    private func errorWidget(_ error: EntryError) -> some View {
        switch error {
        case .recoverable(let message):
            ErrorWidgetView(date: entry.date, message: message)
        case .fatal(let message):
            FatalErrorWidgetView(message: message)
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
        .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
