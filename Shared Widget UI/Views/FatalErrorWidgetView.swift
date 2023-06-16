//
//  FatalErrorWidgetView.swift
//  Aire Libre WidgetExtension
//
//  Created by Marcio Duarte on 2023-05-31.
//

import SwiftUI
import WidgetKit

struct FatalErrorWidgetView: View {
    var message: String
    
    var body: some View {
        Text(message)
            .font(.callout)
            .multilineTextAlignment(.center)
            .minimumScaleFactor(0.8)
            .padding()
    }
}

struct FatalErrorWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        FatalErrorWidgetView(message: "Mensaje error")
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
