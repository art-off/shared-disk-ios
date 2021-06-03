//
//  Manager.swift
//  shared-disk (iOS)
//
//  Created by Artem Rylov on 03.06.2021.
//

import Foundation

struct Manager: Identifiable, Decodable {
    
    let id: Int
    let email: String
    let name: String
}
