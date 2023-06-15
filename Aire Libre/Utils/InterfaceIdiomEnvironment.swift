//
//  InterfaceIdiomEnvironment.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2023-06-11.
//

import SwiftUI

private struct UserInterfaceIdiomEnvironment: EnvironmentKey {
    static let defaultValue = UIUserInterfaceIdiom.phone
}

extension EnvironmentValues {
    var userInterfaceIdiom: UIUserInterfaceIdiom {
        get { self[UserInterfaceIdiomEnvironment.self] }
        set { self[UserInterfaceIdiomEnvironment.self] = newValue }
    }
}
