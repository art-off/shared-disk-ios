//
//  UserResponse.swift
//  shared-disk (iOS)
//
//  Created by Artem Rylov on 24.05.2021.
//

import Foundation

class UserResponse: Decodable {
    
    let id: Int
    let name: String
    let email: String
    let token: String
    let is_manager: Bool
}
