//
//  Decodable+JSONFile.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2022-12-04.
//

import Foundation

// Taken from https://stackoverflow.com/a/73789534/862280

enum JSONParseError: Error {
    case fileNotFound
    case dataInitialisation(error: Error)
    case decoding(error: Error)
}

extension Decodable {
    static func from(localJSON filename: String,
                     bundle: Bundle = .main) -> Result<Self, JSONParseError> {
        guard let url = bundle.url(forResource: filename, withExtension: "json") else {
            return .failure(.fileNotFound)
        }
        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch let error {
            return .failure(.dataInitialisation(error: error))
        }

        do {
            return .success(try JSONDecoder().decode(self, from: data))
        } catch let error {
            return .failure(.decoding(error: error))
        }
    }
}
