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
    private let showFavoriteIcon: Bool
    
    @Binding var favorited: Bool
    
    init(sensorName: String,
         aqiIndex: Int,
         favorited: Binding<Bool>,
         showFavoriteIcon: Bool = true) {
        self.sensorName = sensorName
        self.aqiIndex = aqiIndex
        self.level = AQILevel.fromIndex(aqiIndex)
        self._favorited = favorited
        self.showFavoriteIcon = showFavoriteIcon
    }
    
    init(aqiData: AQIData) {
        self.init(sensorName: aqiData.description,
                  aqiIndex: aqiData.quality.index,
                  favorited: .constant(aqiData.isFavoriteSensor))
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top, spacing: 24) {
                AQIGauge(index: aqiIndex)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(sensorName)
                        .font(.caption.weight(.medium))
                        .fixedSize(horizontal: false, vertical: true)
                    
                    if let level {
                        Text(level.name)
                            .font(.title2.weight(.medium))
                    }
                }
                
                Spacer()
                
                if showFavoriteIcon {
                    favoriteIcon
                        .onTapGesture {
                            favorited.toggle()
                        }
                }
            }
            
            if let level {
                Text(level.description)
                    .font(.caption.weight(.regular))
            }
        }
        .padding()
        .animation(nil, value: UUID())
    }
    
    @ViewBuilder
    private var favoriteIcon: some View {
        if favorited {
            Image(systemName: "star.fill")
                .foregroundColor(Color.yellow)
        } else {
            Image(systemName: "star")
        }
    }
}

struct SensorInfo_Previews: PreviewProvider {
    static var previews: some View {
        SensorInfo(sensorName: "Surubi'i",
                   aqiIndex: 50,
                   favorited: .constant(true))
        .padding()
    }
}
