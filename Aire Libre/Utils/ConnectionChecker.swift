//
//  ConnectionChecker.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2022-11-23.
//

import Foundation
import Network

protocol ConnectionChecker {
    var isConnected: Bool { get }
}

final class NWPathMonitorConnectionChecker: ConnectionChecker {
    private let monitor = NWPathMonitor()
    
    var isConnected: Bool {
        return monitor.currentPath.status == .satisfied
    }
}
