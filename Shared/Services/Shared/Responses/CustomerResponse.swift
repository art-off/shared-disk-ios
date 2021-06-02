//
//  CustomerResponse.swift
//  shared-disk
//
//  Created by Artem Rylov on 02.06.2021.
//

import Foundation

class CusromerResponse: Decodable {
    let workers: [Cusromer]
}

class Cusromer: Identifiable, Decodable {
    
    let id: Int
    let email: String
    let first_name: String
    let last_name: String
    let middle_name: String
}
