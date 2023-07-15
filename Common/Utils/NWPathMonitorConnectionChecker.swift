//
//  NWPathMonitorConnectionChecker.swift
//  Aire Libre Widget watchOS
//
//  Created by Marcio Duarte on 2023-07-02.
//

import Network
import OSLog

/// A connection checker based on NWPathMonitor
final class NWPathMonitorConnectionChecker: ConnectionChecker {
    private let log = Logger(subsystem: AppConstants.bundleId,
                             category: String(describing: NWPathMonitorConnectionChecker.self))
    private let queue = DispatchQueue(label: "NWPathMonitorConnectionChecker.re.airelib.ios")
    private let monitor: NWPathMonitor
    
    init() {
        monitor = NWPathMonitor()
        monitor.start(queue: queue)
        log.debug("NWPathMonitor started")
    }
    
    var isConnected: Bool {
        let currentPath = monitor.currentPath
        let isConnected = currentPath.status == .satisfied
        
        log.info("Current path \(currentPath.debugDescription), isConnected is \(isConnected)")
        
        return isConnected
    }
}
