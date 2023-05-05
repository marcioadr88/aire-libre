//
//  WidgetConfiguration.swift
//  Aire Libre WidgetExtension
//
//  Created by Marcio Duarte on 2023-05-03.
//

import WidgetKit
import SwiftUI

struct AQIWidgetConfiguration: Widget {
    let kind: String = "re.airelib.widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: AQIWidgetProvider()) { entry in
            WidgetView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

