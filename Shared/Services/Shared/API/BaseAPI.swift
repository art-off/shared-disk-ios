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
                 jsonData: Data? = nil) -> URLRequest {
        
        let pathWithSlash = (path.first == "/") ? path : "/" + path
        var url = URL(string: "\(stringAddress)\(pathWithSlash)")!
        
        if let queryParams = queryParams {
            for (name, value) in queryParams {
                url = url.appedingQueryItem(name, value: value)
            }
        }
        
        var request = URLRequest(url: URL(string: "\(stringAddress)\(path)")!)
        request.httpMethod = method.rawValue
        if let jsonData = jsonData {
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        return request
    }
    
    func request(_ method: HTTPMethod,
                 path: String,
                 queryParams: [String: String]? = nil,
                 json: [String: Any]? = nil) -> URLRequest {
        
        var jsonData: Data?
        if let json = json {
            jsonData = try? JSONSerialization.data(withJSONObject: json, options: [])
        }
        let request = self.request(method, path: path, queryParams: queryParams, jsonData: jsonData)
        
        return request
    }
    
    func requestWithBearerToken(_ method: HTTPMethod,
                                token: String,
                                path: String,
                                queryParams: [String: String]? = nil,
                                jsonData: Data? = nil) -> URLRequest {
        
        var request = self.request(method, path: path, queryParams: queryParams, jsonData: jsonData)
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func requestWithBearerToken(_ method: HTTPMethod,
                                token: String,
                                path: String,
                                queryParams: [String: String]? = nil,
                                json: [String: Any]? = nil) -> URLRequest {
        
        var request = self.request(method, path: path, queryParams: queryParams, json: json)
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
    }
}
