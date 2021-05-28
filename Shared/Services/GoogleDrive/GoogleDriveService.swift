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
            token: "354222e10b9fd3fe03ff39e21a0b8819060e0c77fb7e5ee9fdeadf276f777c52",
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
}
