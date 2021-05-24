//
//  MyAPIService.swift
//  shared-disk (iOS)
//
//  Created by Artem Rylov on 24.05.2021.
//

import Foundation

class MyAPIServic {
    
    private let serverService = BaseAPIService(stringAddress: "http://193.187.174.20")
    
    func registration(login: String, password: String, completion: @escaping (Bool) -> Void) {
        serverService.load(
            StatusResponse.self,
            method: .post,
            path: "/registration",
            json: [
                "name": login,
                "password": password,
            ],
            completion: { status in
                print(status)
                completion(status != nil)
            }
        )
    }
}
