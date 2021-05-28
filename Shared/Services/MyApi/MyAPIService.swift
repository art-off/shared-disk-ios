//
//  MyAPIService.swift
//  shared-disk (iOS)
//
//  Created by Artem Rylov on 24.05.2021.
//

import Foundation

class MyAPIServic {
    
    private let serverService = BaseAPIService(stringAddress: "http://193.187.174.20")
    
    func registration(login: String, password: String, completion: @escaping (String) -> Void) {
        serverService.load(
            StatusResponse.self,
            method: .post,
            path: "/registration",
            json: [
                "name": login,
                "password": password,
            ],
            completion: { status in
                switch status {
                case .failure(let error):
                    completion(error.description)
                case .success(let response):
                    completion(response.status)
                }
            }
        )
    }
    
    func auth(login: String, password: String, completion: @escaping (Bool) -> Void) {
        serverService.load(
            TokenResponse.self,
            method: .post,
            path: "/auth",
            json: [
                "name": login,
                "password": password,
            ],
            completion: { tokenResult in
                switch tokenResult {
                case .failure(_):
                    completion(false)
                case .success(let tokenResponse):
                    UserStorage.myToken = tokenResponse.token
                    completion(true)
                }
            }
        )
    }
}
