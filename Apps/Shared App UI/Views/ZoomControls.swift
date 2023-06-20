//
//  ZoomControls.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2023-03-20.
//

import SwiftUI

struct ZoomControls: View {
    private let buttonSize: CGFloat = 32.0
    let plusButtonCallback: VoidCallback?
    let minusButtonCallback: VoidCallback?
    
    init(plusButtonCallback: VoidCallback? = nil,
         minusButtonCallback: VoidCallback? = nil) {
        self.plusButtonCallback = plusButtonCallback
        self.minusButtonCallback = minusButtonCallback
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Button {
                plusButtonCallback?()
            } label: {
                Image(systemName: "plus")
                    .frame(width: buttonSize, height: buttonSize)
                    .contentShape(Rectangle())
            }
            
            Divider()
            
            Button {
                minusButtonCallback?()
            } label: {
                Image(systemName: "minus")
                    .frame(width: buttonSize, height: buttonSize)
                    .contentShape(Rectangle())
            }
        }
        .buttonStyle(.borderless)
        .frame(width: buttonSize)
    }
}

struct ZoomControls_Previews: PreviewProvider {
    static var previews: some View {
        ZoomControls()
    }
}
