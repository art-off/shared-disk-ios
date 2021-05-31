//
//  MyAPIService.swift
//  shared-disk (iOS)
//
//  Created by Artem Rylov on 24.05.2021.
//

import Foundation

class MyAPIServic {
    
    private let serverService = BaseAPIService(stringAddress: "http://193.187.174.20")
    
    func registration(login: String, email: String, password: String, completion: @escaping (String) -> Void) {
        serverService.load(
            StatusResponse.self,
            method: .post,
            path: "/registration",
            json: .dict([
                "name": login,
                "email": email,
                "password": password,
            ]),
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
    
    func auth(email: String, password: String, completion: @escaping (Bool) -> Void) {
        serverService.load(
            UserResponse.self,
            method: .post,
            path: "/auth",
            json: .dict([
                "email": email,
                "password": password,
            ]),
            completion: { tokenResult in
                switch tokenResult {
                case .failure(_):
                    completion(false)
                case .success(let userResponse):
                    UserStorage.myToken = userResponse.token
                    UserStorage.email = userResponse.email
                    UserStorage.login = userResponse.name
                    completion(true)
                }
            }
        )
    }
}
