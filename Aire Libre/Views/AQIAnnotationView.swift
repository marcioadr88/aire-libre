//
//  AQIAnnotationView.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2022-12-05.
//

import SwiftUI
import MapKit

struct AQIAnnotationView: View {
    @ScaledMetric(relativeTo: .caption)
    private var size: CGFloat = 24

    private let aqiIndex: Int
    private let color: Color
    
    init(aqiIndex: Int, color: Color) {
        self.aqiIndex = aqiIndex
        self.color = color
    }
    
    init?(aqiData: AQIData) {
        let aqiIndex = aqiData.quality.index
        
        guard let aqiCategory = AQICategory.fromIndex(aqiIndex) else {
            return nil
        }
        
        self.init(aqiIndex: aqiIndex, color: aqiCategory.color)
    }
    
    var body: some View {
        ZStack {
            if #available(iOS 16.0, *) {
                Circle()
                    .frame(width: size, height: size)
                    .foregroundStyle(
                        color
                            .gradient
                            .shadow(.drop(radius: 1))
                    )
            } else {
                Circle()
                    .frame(width: size, height: size)
                    .foregroundStyle(color)
                    .shadow(radius: 1)
            }
            
            Text("\(aqiIndex)")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
    }
}

#if DEBUG
struct AQIAnnotationView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            AQIAnnotationView(aqiIndex: 1, color: .red)
            AQIAnnotationView(aqiIndex: 10, color: .orange)
            AQIAnnotationView(aqiIndex: 50, color: .green)
            AQIAnnotationView(aqiIndex: 100, color: .purple)
            AQIAnnotationView(aqiIndex: 500, color: .yellow)
        }
    }
}
#endif
