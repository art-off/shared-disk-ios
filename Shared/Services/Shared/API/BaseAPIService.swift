//
//  BaseAPIService.swift
//  shared-disk (iOS)
//
//  Created by Artem Rylov on 22.05.2021.
//

import Foundation

class BaseAPIService {
    
    let session = URLSession(configuration: URLSessionConfiguration.default)
    var task: URLSessionDataTask?
    
    private let baseApi: BaseAPI
    
    init(stringAddress: String) {
        baseApi = BaseAPI(stringAddress: stringAddress)
    }
    
    func downloadFile(name: String,
                      path: String,
                      queryParams: [String: String]? = nil,
                      token: String? = nil,
                      completion: @escaping (Result<Bool, AppError>) -> Void) {
        
        let request = getRequest(path: path, method: .get, token: token, queryParams: queryParams, json: nil, headers: nil)
        
        let downloadsDirectoryUrl = createDownloadsFolderIfNeeded()
        
        session.downloadTask(with: request) { tmpLocalUrl, response, error in
            guard
                error == nil,
                let tmpLocalUrl = tmpLocalUrl
            else {
                completion(.failure(.unowned))
                return
            }
            
            var index = 0
            while true {
                do {
                    try FileManager.default.copyItem(
                        at: tmpLocalUrl,
                        to: downloadsDirectoryUrl.appendingPathComponent(name + (index != 0 ? String(index) : ""))
                    )
                    break
                } catch {
                    index += 1
                }
            }
            completion(.success(true))
        }.resume()
    }
    
    /// Запускает сетевой запрос
    ///
    /// - parameters:
    ///     - type: Тип объекта, который загружается в json
    ///     - method: Метод запроса (GET, POST, PUT)
    ///     - path: Путь для запроса (прибавляющийся к основному адресу)
    ///     - completion: блок кода, который выполнится в конце загрузки
    ///
    func load<T: Decodable>(_ type: T.Type,
                            method: BaseAPI.HTTPMethod,
                            path: String,
                            token: String? = nil,
                            queryParams: [String: String]? = nil,
                            json: BaseAPI.JSONType? = nil,
                            headers: [String: String]? = nil,
                            completion: @escaping (Result<T, AppError>) -> Void) {
        
        let request = getRequest(path: path, method: method, token: token, queryParams: queryParams, json: json, headers: headers)

        task = session.dataTask(with: request) { data, response, error in
            let handleResult = self.handleResponse(T.self, data, response, error)
            completion(handleResult)
        }
        task?.resume()
    }
    
    func cancelLoad() {
        task?.cancel()
    }
    
    // MARK: Helper Methods
    private func handleResponse<T: Decodable>(_ type: T.Type,
                                              _ data: Data?,
                                              _ response: URLResponse?,
                                              _ error: Error?) -> Result<T, AppError> {
        guard let data = data else { return .failure(.network) }
        
        print("RESPONSE")
        print(try? JSONSerialization.jsonObject(with: data, options: []))
        print((response as? HTTPURLResponse)?.statusCode)
        
        if let object = try? JSONDecoder().decode(T.self, from: data) {
            return .success(object)
        }
        if let error = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
            dump(error)
            do {
                _ = try JSONDecoder().decode(T.self, from: data)
            } catch let jsonError {
                print(jsonError)
            }
            return .failure(.init(stringError: error.error))
        }
        do {
            _ = try JSONDecoder().decode(T.self, from: data)
        } catch let jsonError {
            print(jsonError)
        }
        return .failure(.unowned)
    }
    
    private func getRequest(path: String,
                            method: BaseAPI.HTTPMethod,
                            token: String?,
                            queryParams: [String: String]?,
                            json: BaseAPI.JSONType?,
                            headers: [String: String]?) -> URLRequest {
        let request: URLRequest
        if let token = token {
            request = baseApi.requestWithBearerToken(
                method,
                token: token,
                path: path,
                queryParams: queryParams,
                json: json,
                headers: headers
            )
        } else {
            request = baseApi.request(method, path: path, queryParams: queryParams, json: json, headers: headers)
        }
        return request
    }
    
    private func createDownloadsFolderIfNeeded() -> URL {
        let fileManager = FileManager.default
        let downloadsDirectoryUrl = try! fileManager.url(for: .downloadsDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("shared-disk")
        
        if !fileManager.fileExists(atPath: downloadsDirectoryUrl.path) {
            try! fileManager.createDirectory(at: downloadsDirectoryUrl, withIntermediateDirectories: true, attributes: nil)
        }
        
        return downloadsDirectoryUrl
    }
}
