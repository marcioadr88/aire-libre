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
    
    init(aqiData: AQIData, subtitle: String? = nil) {
        self.init(title: aqiData.description,
                  subtitle: subtitle,
                  aqiIndex: aqiData.quality.index,
                  favorited: .constant(aqiData.isFavoriteSensor))
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
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
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
        SensorInfo(title: "Surubi'i",
                   subtitle: nil,
                   aqiIndex: 50,
                   favorited: .constant(true))
        .padding()
    }
}
