//
//  Aire_Libre_Widget.swift
//  Aire Libre Widget
//
//  Created by Marcio Duarte on 2023-05-03.
//

import WidgetKit
import SwiftUI

struct AQIWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> AQIEntry {
        AQIEntry(date: Date(), location: "Placeholder", aqiIndex: 0)
    }

    func getSnapshot(in context: Context, completion: @escaping (AQIEntry) -> ()) {
        let entry = AQIEntry(date: Date(), location: "Snapshot", aqiIndex: 0)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<AQIEntry>) -> ()) {
        let entries: [AQIEntry] = [
            AQIEntry(date: Date(), location: "Entry 1", aqiIndex: 10),
            AQIEntry(date: Date(), location: "Entry 2", aqiIndex: 20),
        ]

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
//        let currentDate = Date()
//        for hourOffset in 0 ..< 5 {
//            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
//            let entry = SimpleEntry(date: entryDate)
//            entries.append(entry)
//        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}
