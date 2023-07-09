//
//  NavigationPathStore.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2023-04-19.
//

import SwiftUI

class NavigationPathStore: ObservableObject {
    private static let pathStoreKey = "SavedPathStore"
    
    @Published var path = NavigationPath() {
        didSet {
            save()
        }
    }
    
    private let savePath = URL.documentsDirectory.appending(path: NavigationPathStore.pathStoreKey)
    
    init() {
        if let data = try? Data(contentsOf: savePath) {
            if let decoded = try? JSONDecoder()
                .decode(NavigationPath.CodableRepresentation.self, from: data) {
                path = NavigationPath(decoded)
                return
            }
        }
    }
    
    func save() {
        guard let representation = path.codable else { return }
        
        DispatchQueue.global(qos: .background).async { [savePath] in
            let data = try? JSONEncoder().encode(representation)
            try? data?.write(to: savePath)
        }
    }
}
