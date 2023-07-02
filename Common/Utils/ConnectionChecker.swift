//
//  ConnectionChecker.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2022-11-23.
//

import Foundation

/// Abstract protocol to determine if there's and active connection to the network
protocol ConnectionChecker {
    var isConnected: Bool { get async }
}
