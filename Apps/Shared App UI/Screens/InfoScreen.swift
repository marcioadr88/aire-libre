//
//  InfoScreen.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2023-06-17.
//

import SwiftUI

struct InfoScreen: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Group {
                    Text(Localizables.whatsAireLibreTitle)
                        .font(.title.bold())
                    
                    Text(Localizables.whatsAireLibreDescription)
                        .font(.body)
                    
                    Spacer(minLength: 16)
                    
                    Text(Localizables.whatsAQITitle)
                        .font(.title.bold())
                    
                    Text(Localizables.whatsAQIDescription)
                        .font(.body)
                }
                
                Group {
                    Spacer(minLength: 16)
                    
                    Text(Localizables.aqiScaleTitle)
                        .font(.title.bold())
    
                    aqiTable
                }
                .tint(Color.blue)
                
                Group {
                    Spacer(minLength: 16)
                    
                    Text(Localizables.knowMoreProject)
                        .font(.title.bold())
                    
                    Text(.init(Localizables.collaborateWithProject))
                        .font(.body)
                }
                .tint(Color.blue)
            }
            .lineLimit(nil)
            .multilineTextAlignment(.leading)
            .padding()
        }
    }
    
    @ViewBuilder
    private var aqiTable: some View {
        ForEach(AQILevel.allCases) { aqiLevel in
            Spacer(minLength: 6)
            
            VStack(alignment: .leading, spacing: 6) {
                Group {
                    Text("\(Image(systemName: aqiLevel.symbol))")
                    +
                    Text(" ")
                    +
                    Text(aqiLevel.name)
                    +
                    Text(" - ")
                    +
                    Text("\(aqiLevel.range.lowerBound)")
                    +
                    Text(" \(Localizables.to) ")
                    +
                    Text("\(aqiLevel.range.upperBound)")
                }
                .font(.title3.bold())
                .foregroundColor(aqiLevel.color)
                
                Text(aqiLevel.description)
                    .font(.body)
                    .lineSpacing(2)
            }
            .multilineTextAlignment(.leading)
            
            Spacer(minLength: 6)
        }
        
        Spacer(minLength: 6)
        
        Text(.init(Localizables.scaleSource))
            .font(.caption)
    }
}

struct InfoScreen_Previews: PreviewProvider {
    static var previews: some View {
        InfoScreen()
    }
}
