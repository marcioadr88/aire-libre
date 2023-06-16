//
//  ConnectionChecker.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2022-11-23.
//

import Foundation
import Network
import OSLog

protocol ConnectionChecker {
    var isConnected: Bool { get }
}

final class NWPathMonitorConnectionChecker: ConnectionChecker {
    private let log = Logger(subsystem: "connection_checker.re.airelib.ios",
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
