//
//  Worker.swift
//  shared-disk
//
//  Created by Artem Rylov on 02.06.2021.
//

import Foundation

struct Worker: Identifiable, Codable {
    
    let id: Int
    let email: String
    let name: String
    let professionType: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case name
        case professionType = "profession_type.id"
    }
}
