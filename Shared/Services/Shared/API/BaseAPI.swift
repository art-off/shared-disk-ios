//
//  BaseAPI.swift
//  shared-disk (iOS)
//
//  Created by Artem Rylov on 22.05.2021.
//

import Foundation

struct BaseAPI {
    
    private let stringAddress: String
    
    init(stringAddress: String) {
        self.stringAddress = stringAddress
    }
    
    
    // MARK: - Helper Methods (Request)
    func request(_ method: HTTPMethod,
                 path: String,
                 queryParams: [String: String]? = nil,
                 andJsonData jsonData: Data? = nil) -> URLRequest {
        
        let pathWithSlash = (path.first == "/") ? path : "/" + path
        var url = URL(string: "\(stringAddress)\(pathWithSlash)")!
        
        if let queryParams = queryParams {
            for (name, value) in queryParams {
                url = url.appedingQueryItem(name, value: value)
            }
        }
        
        var request = URLRequest(url: URL(string: "\(stringAddress)\(path)")!)
        request.httpMethod = method.rawValue
        request.httpBody = jsonData
        
        return request
    }
    
    func requestWithBearerToken(_ method: HTTPMethod,
                                token: String,
                                path: String,
                                queryParams: [String: String]? = nil,
                                andJsonData jsonData: Data? = nil) -> URLRequest {
        
        var request = self.request(method, path: path, queryParams: queryParams, andJsonData: jsonData)
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
    }
}
