//
//  Customer.swift
//  shared-disk (iOS)
//
//  Created by Artem Rylov on 03.06.2021.
//

import Foundation

struct Customer: Identifiable, Decodable {
    
    let id: Int
    let email: String
    let first_name: String
    let last_name: String
    let middle_name: String
}
