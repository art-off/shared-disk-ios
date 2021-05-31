//
//  GoogleDriveService.swift
//  shared-disk (iOS)
//
//  Created by Artem Rylov on 22.05.2021.
//

import Foundation

class GoogleDriveService {
    
    private let serverService = BaseAPIService(stringAddress: "http://193.187.174.20")
    
    private let googleService = BaseAPIService(stringAddress: "https://www.googleapis.com")
    
    
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
                }
            }
        )
    }
    
    func uploadFile(fileUrl: URL, name: String, folderID: String, completion: @escaping (Result<Bool, AppError>) -> Void) {
        let (data, boundary) = dataAndBoundaryForUploadFile(fileUrl: fileUrl, name: name, folderID: folderID)
        
        googleService.load(
            FilesResponse.self,
            method: .post,
            path: "/upload/drive/v3/files",
            token: UserStorage.googleToken,
            queryParams: [
                "uploadType": "multipart",
                "key": "AIzaSyA2XuDTRAAyBFbDwbuWq-B_WvRm8HDT2x8",
            ],
            json: .data(data),
            headers: [
                "Content-Type": "multipart/related; boundary=\(boundary)",
                "Content-Length": "\(data.count)",
            ],
            completion: { result in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .success(_):
                    completion(.success(true))
                }
            }
        )
    }
    
    private func dataAndBoundaryForUploadFile(fileUrl: URL, name: String, folderID: String) -> (Data, String) {
        let boundary = UUID().uuidString
        
        let json: [String : Any] = [
            "name": name,
            "parents": [folderID],
        ]
        
        var mimeType: MimeType = .txt
        if let ext = fileUrl.absoluteString.split(separator: ".").last {
            mimeType = MimeType(fromExtention: String(ext)) ?? .txt
        }
        let contentOfFile = (try? Data(contentsOf: fileUrl)) ?? Data()
        
        var data = Data()
        
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Type: application/json; charset=UTF-8\r\n".data(using: .utf8)!)
        data.append("\r\n".data(using: .utf8)!)
        data.append(try! JSONSerialization.data(withJSONObject: json, options: []))
        data.append("\r\n".data(using: .utf8)!)
        
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Type: \(mimeType.stringType)\r\n\r\n".data(using: .utf8)!)
        data.append(contentOfFile)
        
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        return (data, boundary)
    }
}
