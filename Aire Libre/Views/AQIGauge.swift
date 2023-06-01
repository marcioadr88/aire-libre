//
//  AQIGauge.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2022-12-11.
//

import SwiftUI

struct AQIGauge: View {
    private let index: Int?
    
    init(index: Int) {
        self.index = index
    }
    
    init() {
        self.index = nil
    }
    
    private let gradient = Gradient(colors: AQILevel.colors)
    private let aqiIndexRange = Double(AQILevel.minAQIIndex)...Double(AQILevel.maxAQIIndex)
    
    private var value: Double {
        if let index {
            return Double(index)
        } else {
            return 0.0
        }
    }
    
    var body: some View {
        Gauge(value: value, in: aqiIndexRange) {
        } currentValueLabel: {
            valueLabel
                .font(.title2.weight(.medium))
        }
        .gaugeStyle(.accessoryCircular)
        .tint(gradient)
    }
    
    @ViewBuilder
    private var valueLabel: some View {
        if let index {
            Text(index, format: .number)
        } else {
            Text("-")
        }
    }
}

struct AQIGauge_Previews: PreviewProvider {
    static var previews: some View {
        AQIGauge(index: 50)
    }
}
