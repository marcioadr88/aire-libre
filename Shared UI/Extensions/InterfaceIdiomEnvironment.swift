//
//  InterfaceIdiomEnvironment.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2023-06-11.
//

import SwiftUI

enum UserInterfaceIdiom {
    case phone
    case pad
    case mac
    case other
}

#if os(iOS)
import UIKit

extension UserInterfaceIdiom {
    static func from(_ idiom: UIUserInterfaceIdiom) -> UserInterfaceIdiom {
        switch idiom {
        case .pad:
            return .pad
        case .phone:
            return .phone
        case .mac:
            return .mac
        default:
            return .other
        }
    }
}
#endif

private struct UserInterfaceIdiomEnvironment: EnvironmentKey {
    static let defaultValue = UserInterfaceIdiom.phone
}

extension EnvironmentValues {
    var userInterfaceIdiom: UserInterfaceIdiom {
        get { self[UserInterfaceIdiomEnvironment.self] }
        set { self[UserInterfaceIdiomEnvironment.self] = newValue }
    }
}
