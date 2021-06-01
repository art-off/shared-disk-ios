//
//  FileRevisionResponse.swift
//  shared-disk
//
//  Created by Artem Rylov on 01.06.2021.
//

import Foundation

class FileRevisionResponse: Decodable {
    
    let kind: String
    let revisions: [FileRevision]
}
