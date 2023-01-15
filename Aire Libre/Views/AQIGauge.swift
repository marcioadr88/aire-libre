//
//  AQIGauge.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2022-12-11.
//

import SwiftUI

struct AQIGauge: View {
    private let index: Int
    
    init(index: Int) {
        self.index = index
    }
    
    private let gradient = Gradient(colors: AQILevel.colors)
    private let aqiIndexRange = Double(AQILevel.minAQIIndex)...Double(AQILevel.maxAQIIndex)
    
    var body: some View {
        Gauge(value: Double(index), in: aqiIndexRange) {
        } currentValueLabel: {
            Text(index, format: .number)
                .font(.title2.weight(.medium))
        }
        .gaugeStyle(.accessoryCircular)
        .tint(gradient)
    }
}

struct AQIGauge_Previews: PreviewProvider {
    static var previews: some View {
        AQIGauge(index: 50)
    }
}
