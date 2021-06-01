//
//  FileRevision.swift
//  shared-disk
//
//  Created by Artem Rylov on 01.06.2021.
//

import Foundation

struct FileRevision: Identifiable {
    
    let id: String
    let mimeType: String
    let modifiedTime: String
    let fileName: String
    let size: String
    let modifiedUser: ModifiedUser
}

extension FileRevision: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case mimeType
        case modifiedTime
        case fileName = "originalFilename"
        case size
        case modifiedUser = "lastModifyingUser"
    }
}

struct ModifiedUser {
    
    let displayName: String
    let email: String
    
}

extension ModifiedUser: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case displayName
        case email = "emailAddress"
    }
}
