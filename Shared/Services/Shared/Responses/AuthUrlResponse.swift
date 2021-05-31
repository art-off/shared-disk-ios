//
//  AuthUrlResponse.swift
//  shared-disk (iOS)
//
//  Created by Artem Rylov on 31.05.2021.
//

import Foundation

class AuthUrlResponse: Decodable {
    
    let authorizationUrl: URL
    
    enum CodingKeys: String, CodingKey {
        case authorizationUrl = "authorization_url"
    }
}
