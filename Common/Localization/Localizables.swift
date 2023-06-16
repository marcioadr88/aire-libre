//
//  Localizables.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2022-11-23.
//

import Foundation

@dynamicMemberLookup
final class Localizables {
    private init() {}
    
    private static let stringsName = "Strings"
    
    static subscript(dynamicMember member: String) -> String {
        NSLocalizedString(member, tableName: stringsName,
                          bundle: Bundle.main,
                          comment: "")
    }
    
    static subscript(dynamicMember member: String) -> (_ arguments: CVarArg...) -> String {
        { arguments in
            String(format: Localizables[dynamicMember: member],
                   arguments: arguments)
        }
    }
}
