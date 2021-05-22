//
//  FilesResponse.swift
//  shared-disk (iOS)
//
//  Created by Artem Rylov on 22.05.2021.
//

import Foundation

struct FilesResponse {
    
    let files: [FileItem]
    let nextPageToken: String?
}

extension FilesResponse: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case files
        case nextPageToken = "next_page_token"
    }
}
