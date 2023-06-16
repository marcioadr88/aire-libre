//
//  WidgetURLUtils.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2023-06-16.
//

import Foundation

final class WidgetURLUtils {
    private init() {}
    
    static func widgetOpenURL(for source: String) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = AppConstants.scheme
        
        urlComponents.queryItems = [
            URLQueryItem(name: AppConstants.selectedSourceQueryParam,
                         value: source)
        ]
        
        return urlComponents.url
    }
    
    static func source(forWidgetOpenURL url: URL) -> String? {
        guard url.scheme == AppConstants.scheme else {
            return nil
        }
        
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItems = components?.queryItems
        
        let queryParam = queryItems?.first(where: {
            $0.name == AppConstants.selectedSourceQueryParam
        })
        
        return queryParam?.value
    }
}
