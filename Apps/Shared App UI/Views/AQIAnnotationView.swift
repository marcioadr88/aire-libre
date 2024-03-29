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
    
    @Binding private var isSelected: Bool
    
    init(aqiIndex: Int, color: Color, isSelected: Binding<Bool> = .constant(false)) {
        self.aqiIndex = aqiIndex
        self.color = color
        self._isSelected = isSelected
    }
    
    init?(aqiData: AQIData, isSelected: Binding<Bool> = .constant(false)) {
        let aqiIndex = aqiData.quality.index
        
        guard let aqiCategory = AQILevel.fromIndex(aqiIndex) else {
            return nil
        }
        
        self.init(aqiIndex: aqiIndex,
                  color: aqiCategory.color,
                  isSelected: isSelected)
    }
    
    var body: some View {
        ZStack {
            Color.clear
                .frame(width: size, height: size)
                .background(color.gradient, in: Circle())
                .shadow(radius: 1)
                .brightness(isSelected ? -0.2 : 0)
            
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
