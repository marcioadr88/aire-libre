//
//  JSONFileLoader.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2022-12-04.
//

import Foundation

final class JSONFileLoader {
    private init() {}
    
    static func loadJsonFileOrFail<T: Decodable>(_ fileName: String) -> T {
        switch T.from(localJSON: fileName) {
        case .success(let data):
            return data
        case .failure(let error):
            fatalError("Cannot parse \(fileName).json \(error.localizedDescription)")
        }
    }
}
