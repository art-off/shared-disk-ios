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
                 queryParams: [String: String]?,
                 json: JSONType?,
                 headers: [String: String]?) -> URLRequest {
        
        let pathWithSlash = (path.first == "/") ? path : "/" + path
        var url = URL(string: "\(stringAddress)\(pathWithSlash)")!
        
        if let queryParams = queryParams {
            for (name, value) in queryParams {
                url = url.appedingQueryItem(name, value: value)
            }
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        if let json = json {
            switch json {
            case .data(let jsonData):
                request.httpBody = jsonData
            case .dict(let jsonDict):
                request.httpBody = try? JSONSerialization.data(withJSONObject: jsonDict, options: [])
            }
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        if let headers = headers {
            request.allHTTPHeaderFields = headers
        }
        
        return request
    }
    
    func requestWithBearerToken(_ method: HTTPMethod,
                                token: String,
                                path: String,
                                queryParams: [String: String]? = nil,
                                json: JSONType? = nil,
                                headers: [String: String]? = nil) -> URLRequest {
        
        var request = self.request(method, path: path, queryParams: queryParams, json: json, headers: headers)
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    enum JSONType {
        case data(Data)
        case dict([String: Any])
    }
}
