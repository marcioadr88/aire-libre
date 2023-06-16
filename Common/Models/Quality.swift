//
//  Quality.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2022-11-06.
//

import Foundation

struct Quality: Codable, Equatable, Hashable {
    let category: String
    let index: Int
}

extension Quality {
    func copy(category: String? = nil, index: Int? = nil) -> Quality {
        return Quality(category: category ?? self.category,
                       index: index ?? self.index)
    }
}
