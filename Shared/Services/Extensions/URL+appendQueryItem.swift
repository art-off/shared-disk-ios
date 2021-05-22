//
//  URL+appendQueryItem.swift
//  shared-disk (iOS)
//
//  Created by Artem Rylov on 22.05.2021.
//

import Foundation

extension URL {
    
    func appedingQueryItem(_ qyeryName: String, value: String) -> Self {
        guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }
        
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
        
        queryItems.append(URLQueryItem(name: qyeryName, value: value))

        urlComponents.queryItems = queryItems
        
        return urlComponents.url!
    }
}
