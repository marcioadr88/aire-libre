//
//  SensorInfo.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2022-12-10.
//

import SwiftUI

struct SensorInfo: View {
    private let sensorName: String
    private let aqiIndex: Int
    private let level: AQILevel?
    
    init(sensorName: String, aqiIndex: Int) {
        self.sensorName = sensorName
        self.aqiIndex = aqiIndex
        self.level = AQILevel.fromIndex(aqiIndex)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top, spacing: 24) {
                AQIGauge(index: aqiIndex)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(sensorName)
                        .font(.caption.weight(.medium))
                    
                    if let level {
                        Text(level.name)
                            .font(.title2.weight(.medium))
                    }
                }
                
                Spacer()
                
                Image(systemName: "star")
            }
            
            if let level {
                Text(level.description)
                    .font(.caption.weight(.regular))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color.white)
        )
        .animation(nil, value: UUID())
    }
}

struct SensorInfo_Previews: PreviewProvider {
    static var previews: some View {
        SensorInfo(sensorName: "Surubi'i",
                   aqiIndex: 50)
        .padding()
    }
}
