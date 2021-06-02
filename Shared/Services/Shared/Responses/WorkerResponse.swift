//
//  WorkerResponse.swift
//  shared-disk
//
//  Created by Artem Rylov on 02.06.2021.
//

import Foundation

class WorkerResponse: Decodable {
    let workers: [Worker]
}
