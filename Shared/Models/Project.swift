//
//  Project.swift
//  shared-disk
//
//  Created by Artem Rylov on 02.06.2021.
//

import Foundation

struct Project {
    
    let name: String
    let deadline: String
    let customer: Cusromer
    let managerId: Int
    let developmentStages: [DevelopmentStage]
}
