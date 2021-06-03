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
                    UserStorage.id = userResponse.id
                    UserStorage.myToken = userResponse.token
                    UserStorage.email = userResponse.email
                    UserStorage.login = userResponse.name
                    UserStorage.isManager = userResponse.is_manager
                    completion(true)
                }
            }
        )
    }
    
    func getCustomers(completion: @escaping ([Cusromer]?) -> Void) {
        serverService.load(
            CusromerResponse.self,
            method: .get,
            path: "/customers",
            token: UserStorage.myToken,
            completion: { result in
                switch result {
                case .failure(_):
                    completion(nil)
                case .success(let r):
                    completion(r.workers)
                }
            }
        )
    }
    
    func getWorkers(completion: @escaping ([Worker]?) -> Void) {
        serverService.load(
            WorkerResponse.self,
            method: .get,
            path: "/workers",
            token: UserStorage.myToken,
            completion: { result in
                switch result {
                case .failure(_):
                    completion(nil)
                case .success(let r):
                    completion(r.workers)
                }
            }
        )
    }
    
    func startProject(project: Project, completion: @escaping (Result<Bool, AppError>) -> Void) {
        var stagesJson: [[String: Any]] = []
        for stage in project.developmentStages {
            var tasksJson: [[String: Any]] = []
            for task in stage.tasks {
                tasksJson.append([
                    "name": task.name,
                    "worker_id": task.worker.id,
                ])
            }
            stagesJson.append([
                "type": stage.type,
                "tasks": tasksJson,
            ])
        }
        let json: [String: Any] = [
            "name": project.name,
            "customer_id": project.customer.id,
            "manager_id": project.managerId,
            "deadline": project.deadline,
            "stages": stagesJson,
        ]
        
        serverService.load(
            StatusResponse.self,
            method: .post,
            path: "/project/start",
            token: UserStorage.myToken,
            json: .dict(json),
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
    
    func getProjects(completion: @escaping (Result<[ProjectResponse], AppError>) -> Void) {
        serverService.load(
            ProjectsResponse.self,
            method: .get,
            path: "/project/get",
            token: UserStorage.myToken,
            completion: { result in
                switch result {
                case .failure(let e):
                    completion(.failure(e))
                case .success(let r):
                    completion(.success(r.projects))
                }
            }
        )
    }
}
