//
//  AppError.swift
//  shared-disk
//
//  Created by Artem Rylov on 28.05.2021.
//

import Foundation

enum AppError: Error {
    
    case network
    
    case passwordToShort
    
    case credentialsIsNotValid
    
    case unowned
    
    
    init(stringError: String) {
        switch stringError {
        case "password_too_short":
            self = .passwordToShort
        case "credentials_is_not_valid":
            self = .credentialsIsNotValid
        default:
            self = .unowned
        }
    }
    
    var description: String {
        switch self {
        case .network:
            return "Проблемы с интернетом"
        case .passwordToShort:
            return "Пароль короткий"
        case .credentialsIsNotValid:
            return "Обновите разрешения"
        case .unowned:
            return "Непонятно"
        }
    }
}
