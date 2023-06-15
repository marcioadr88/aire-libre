//
//  MapScreenViewModel.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2023-03-16.
//

import Foundation
import CoreLocation
import MapKit
import SwiftUI
import OSLog

class MapScreenViewModel: NSObject, ObservableObject {
    private let log = Logger(subsystem: "mapvm.re.airelib.ios",
                             category: String(describing: MapScreenViewModel.self))
    
    private let zoomFactor: CGFloat = 1.5
    private let savePath = URL.documentsDirectory.appending(path: MapScreenViewModel.regionStoreKey)
    
    @Published var region = MKCoordinateRegion(center: AppConstants.asuncionCoordinates,
                                               span: AppConstants.defaultSpan) {
        didSet {
            saveRegion()
        }
    }
    
    @Published var selectedSource: String?
    
    @Published var location: CLLocation? {
        didSet {
            log.debug("User location updated to \(self.location)")
        }
    }
    
    override init() {
        super.init()
        
        loadSavedRegion()
    }
    
    func centerToUserLocation() {
        if let location {
            withAnimation {
                region.center = location.coordinate
            }
        }
    }
    
    func zoomIn() {
        region.span.latitudeDelta *= 1/zoomFactor
        region.span.longitudeDelta *= 1/zoomFactor
    }
    
    func zoomOut() {
        region.span.latitudeDelta *= zoomFactor
        region.span.longitudeDelta *= zoomFactor
    }
}

// MARK: Last used region persistence
extension MapScreenViewModel {
    private static let regionStoreKey = "MapScreenRegion"
    
    func loadSavedRegion() {
        if let data = try? Data(contentsOf: savePath) {
            if let decoded = try? JSONDecoder()
                .decode(MKCoordinateRegion.self, from: data) {
                region = decoded
            }
        }
    }
    
    func saveRegion() {
        DispatchQueue.global(qos: .background).async { [savePath, region] in
            let data = try? JSONEncoder().encode(region)
            try? data?.write(to: savePath)
        }
    }
}
