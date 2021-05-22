//
//  FileItem.swift
//  shared-disk (iOS)
//
//  Created by Artem Rylov on 22.05.2021.
//

import Foundation

struct FileItem {
    
    let id: String
    let name: String
    let mineType: MimeType
}

extension FileItem: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case mineType = "mine_type"
    }
}
