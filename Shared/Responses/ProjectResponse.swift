//
//  ProjectResponse.swift
//  shared-disk (iOS)
//
//  Created by Artem Rylov on 03.06.2021.
//

import Foundation

struct ProjectResponse: Identifiable, Decodable {
    
    let id: Int
    let name: String
    let finish: Bool
    let folder_id: String
    let start_time: String
    let deadline: String
    let customer: Customer
    let manager: Manager
    let stages: [DevelopmentStageResponse]
}

struct DevelopmentStageResponse: Identifiable, Decodable {
    
    let id: Int
    let type: String
    let folder_id: String
    let tasks: [TaskResponse]
}

struct TaskResponse: Identifiable, Decodable {
    
    let id: Int
    let name: String
    var ready: Bool
    var current: Bool
    let folder_id: String
    let customer_folder_id: String
    let finally_folder_id: String
    let worker: WorkerResopnse
}

struct WorkerResopnse: Identifiable, Decodable {
    
    let id: Int
    let name: String
    let email: String
    let profession_type: Int
}
