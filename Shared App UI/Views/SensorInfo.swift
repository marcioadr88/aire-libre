//
//  SensorInfo.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2022-12-10.
//

import SwiftUI

struct SensorInfo: View {
    private let title: String
    private let aqiIndex: Int
    private let level: AQILevel?
    private let showFavoriteIcon: Bool
    private let subtitle: String?
    
    @Binding var favorited: Bool
    
    init(title: String,
         subtitle: String?,
         aqiIndex: Int,
         favorited: Binding<Bool>,
         showFavoriteIcon: Bool = true) {
        self.title = title
        self.subtitle = subtitle
        self.aqiIndex = aqiIndex
        self.level = AQILevel.fromIndex(aqiIndex)
        self._favorited = favorited
        self.showFavoriteIcon = showFavoriteIcon
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top, spacing: 24) {
                AQIGauge(index: aqiIndex)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.subheadline)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    if let subtitle {
                        Text(subtitle)
                            .font(.caption)
                    }
                    
                    if let level {
                        Text(level.name)
                            .font(.title2.weight(.medium))
                    }
                }
                .fixedSize(horizontal: false, vertical: true)
                
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
        .lineLimit(nil)
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

extension SensorInfo {
    static func nearestSensorAware(aqiData data: AQIData,
                                   showFavoriteIcon: Bool = false) -> SensorInfo {
        let title = data.isNearestToUser ? Localizables.myLocation : data.description
        let subtitle = data.isNearestToUser ? data.description : nil
        
        return SensorInfo(title: title,
                   subtitle: subtitle,
                   aqiIndex: data.quality.index,
                   favorited: .constant(data.isFavoriteSensor),
                   showFavoriteIcon: showFavoriteIcon)
    }
}

struct SensorInfo_Previews: PreviewProvider {
    static var previews: some View {
        SensorInfo(title: "Surubi'i",
                   subtitle: "Subtitulo",
                   aqiIndex: 50,
                   favorited: .constant(true))
        .padding()
    }
}
