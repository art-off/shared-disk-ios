//
//  GoogleDriveService.swift
//  shared-disk (iOS)
//
//  Created by Artem Rylov on 22.05.2021.
//

import Foundation

class GoogleDriveService {
    
    private let serverService = BaseAPIService(stringAddress: "http://193.187.174.20")
    
    
    func files(in folder: String = "root", completion: @escaping (Result<[FileItem], AppError>) -> Void) {
        serverService.load(
            FilesResponse.self,
            method: .get,
            path: "/files",
            token: UserStorage.myToken,
            queryParams: ["folder": folder],
            completion: { fileResponseResult in
                switch fileResponseResult {
                case .failure(let error):
                    completion(.failure(error))
                case .success(let fileResponse):
                    completion(.success(fileResponse.files))
                }
            }
        )
    }
    
    func refreshToken(completion: @escaping (Result<URL, AppError>) -> Void) {
        serverService.load(
            AuthUrlResponse.self,
            method: .get,
            path: "/refresh_authorize/google_drive",
            token: UserStorage.myToken,
            completion: { result in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .success(let response):
                    completion(.success(response.authorizationUrl))
                }
            }
        )
    }
    
    func authGoogleDrive(completion: @escaping (Result<Bool, AppError>) -> Void) {
        serverService.load(
            TokenResponse.self,
            method: .get,
            path: "/authorize/google_drive",
            token: UserStorage.myToken,
            completion: { result in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .success(let response):
                    UserStorage.googleToken = response.token
                    completion(.success(true))
//                    completion(.success(response.token))
                }
            }
        )
    }
}
