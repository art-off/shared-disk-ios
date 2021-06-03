//
//  ProjectsResponse.swift
//  shared-disk (iOS)
//
//  Created by Artem Rylov on 03.06.2021.
//

import Foundation

struct ProjectsResponse: Decodable {
    
    let projects: [ProjectResponse]
}
