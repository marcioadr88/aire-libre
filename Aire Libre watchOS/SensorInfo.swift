//
//  SensorInfo.swift
//  Aire Libre watchOS
//
//  Created by Marcio Duarte on 2023-06-18.
//

import SwiftUI

struct SensorInfo: View {
    private let title: String
    private let aqiIndex: Int
    private let level: AQILevel?
    
    init(title: String,
         aqiIndex: Int) {
        self.title = title
        self.aqiIndex = aqiIndex
        self.level = AQILevel.fromIndex(aqiIndex)
    }

    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            AQIGauge(index: aqiIndex)

            VStack(alignment: .leading) {
                Text(title)
                    .font(.caption2)
                    .fixedSize(horizontal: false, vertical: true)
                
                if let condition = level?.name {
                    Text(condition)
                        .font(.body.weight(.medium))
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .multilineTextAlignment(.leading)
        .lineLimit(nil)
    }
}

struct SensorInfo_Previews: PreviewProvider {
    static var previews: some View {
        SensorInfo(title: "Surubi'i",
                   aqiIndex: 50)
    }
}
