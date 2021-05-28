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
                            json: [String: Any]? = nil,
                            completion: @escaping (Result<T, AppError>) -> Void) {
        
        let request: URLRequest
        if let token = token {
            request = baseApi.requestWithBearerToken(method, token: token, path: path, queryParams: queryParams, json: json)
        } else {
            request = baseApi.request(method, path: path, queryParams: queryParams, json: json)
        }

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
    
}
