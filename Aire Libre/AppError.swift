//
//  AppError.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2022-11-22.
//

import Foundation

/// Represents an exception on the app
enum AppError: Error {
    /// The provided endpoint path is not valid
    case invalidEndpoindURL
     
    /// There's no network connection
    case noConnection
    
    /// An network error ocurrs
    case networkError(cause: Error)
    
    /// Cannot parse
    case decodingError(cause: Error)
    
    /// Api returned an error
    case apiError(message: String)
}

/// Provides an user friendly error message
extension AppError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidEndpoindURL:
            return Localizables.invalidEndpoindURL
        case .networkError(let cause):
            return cause.localizedDescription
        case .decodingError(let cause):
            return cause.localizedDescription
        case .apiError(let message):
            return message
        case .noConnection:
            return Localizables.noConnection
        }
    }
}

extension AppError: Equatable {
    static func ==(lhs: AppError, rhs: AppError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidEndpoindURL, .invalidEndpoindURL):
            return true
        case (let .networkError(lhsCause), let .networkError(rhsCause)):
            return lhsCause.localizedDescription == rhsCause.localizedDescription
        case (let .decodingError(lhsCause), let .decodingError(rhsCause)):
            return lhsCause.localizedDescription == rhsCause.localizedDescription
        case (let .apiError(lhsMessage), let .apiError(rhsMessage)):
            return lhsMessage == rhsMessage
        case (.noConnection, .noConnection):
            return true
        default:
            return false
        }
    }
}
