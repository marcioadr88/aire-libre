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
    
    /// Unexpected condition
    case unexpected(message: String?)
    
    /// From other type of Error
    case wrappingError(cause: Error)
    
    /// Persistence error
    case persistence(cause: Error)
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
        case .unexpected(let message):
            return message ?? Localizables.unexpectedError
        case .wrappingError(let cause):
            return cause.localizedDescription
        case .persistence(let cause):
            return cause.localizedDescription
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
        case (.unexpected(let lhsMessage), .unexpected(let rhsMessage)):
            return lhsMessage == rhsMessage
        case (let .wrappingError(lhsCause), let .wrappingError(rhsCause)):
            return lhsCause.localizedDescription == rhsCause.localizedDescription
        case (let .persistence(lhsCause), let .persistence(rhsCause)):
            return lhsCause.localizedDescription == rhsCause.localizedDescription
        default:
            return false
        }
    }
}

extension AppError {
    static func fromError(_ error: Error) -> AppError {
        if let appError = error as? AppError {
            return appError
        } else {
            return AppError.wrappingError(cause: error)
        }
    }
}
