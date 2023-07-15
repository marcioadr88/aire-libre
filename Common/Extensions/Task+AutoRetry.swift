//
//  Task+AutoRetry.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2022-11-29.
//

import Foundation
import OSLog

// taken from https://www.swiftbysundell.com/articles/retrying-an-async-swift-task/
extension Task where Failure == Error {
    @discardableResult
    static func retrying(
        priority: TaskPriority? = nil,
        maxRetryCount: Int = 3,
        retryDelay: TimeInterval = 1,
        operation: @Sendable @escaping () async throws -> Success
    ) -> Task {
        let log = Logger(subsystem: AppConstants.bundleId,
                         category: "Task.retrying")
        
        return Task(priority: priority) {
            for attempNumber in 0..<maxRetryCount {
                do {
                    return try await operation()
                } catch {
                    let oneSecond = TimeInterval(1_000_000_000)
                    let delay = UInt64(oneSecond * retryDelay)
                    try await Task<Never, Never>.sleep(nanoseconds: delay)
                    
                    log.debug("Retrying task - Attempt \(attempNumber + 1)")
                    
                    continue
                }
            }
            
            try Task<Never, Never>.checkCancellation()
            return try await operation()
        }
    }
}
