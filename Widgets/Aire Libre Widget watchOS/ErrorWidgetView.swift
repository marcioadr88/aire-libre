//
//  ErrorWidgetView.swift
//  Aire Libre Widget watchOS
//
//  Created by Marcio Duarte on 2023-07-02.
//

import SwiftUI
import WidgetKit

struct ErrorWidgetView: View {
    @Environment(\.widgetFamily) private var widgetFamily
    
    var message: String
    
    var body: some View {
        switch widgetFamily {
        case .accessoryCircular,
                .accessoryInline,
                .accessoryRectangular:
            errorText
            
        case .accessoryCorner:
            EmptyView()
                .widgetLabel {
                    errorText
                }
            
        @unknown default:
            errorText
        }
        
    }
    
    @ViewBuilder
    private var errorText: some View {
        Text(message)
            .multilineTextAlignment(.center)
            .lineLimit(nil)
            .minimumScaleFactor(0.75)
            .clipShape(ContainerRelativeShape())
    }
}

struct ErrorWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorWidgetView(message: "An error message bla bla")
            .previewContext(WidgetPreviewContext(family: .accessoryCircular))
    }
}
