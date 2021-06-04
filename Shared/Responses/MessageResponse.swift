//
//  MessageResponse.swift
//  shared-disk (iOS)
//
//  Created by Artem Rylov on 04.06.2021.
//

import Foundation

struct MessagesResponse: Decodable {
    
    let messages: [MessageResponse]
}

struct MessageResponse: Identifiable, Decodable {
    
    let id: Int
    let text: String
    let task_name: String?
    let stage_name: String?
    let project_name: String?
    let worker_email: String
    let project_finish: Bool
}
