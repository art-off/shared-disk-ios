//
//  AppError.swift
//  shared-disk
//
//  Created by Artem Rylov on 28.05.2021.
//

import Foundation

enum AppError: Error {
    
    case network
    
    case requiredParamsDoesNotExist
    
    case passwordToShort
    case emailIsNotValid
    
    case credentialsIsNotValid
    
    case unowned
    
    
    init(stringError: String) {
        switch stringError {
        case "password_too_short":
            self = .passwordToShort
        case "credentials_is_not_valid":
            self = .credentialsIsNotValid
        case "email_is_not_valid":
            self = .emailIsNotValid
        case "required_params_does_not_exist":
            self = .requiredParamsDoesNotExist
        default:
            self = .unowned
        }
    }
    
    var description: String {
        switch self {
        case .network:
            return "Проблемы с интернетом"
        case .requiredParamsDoesNotExist:
            return "Не все поля заполнены"
        case .passwordToShort:
            return "Пароль короткий"
        case .emailIsNotValid:
            return "Емаил не валидный"
        case .credentialsIsNotValid:
            return "Обновите разрешения"
        case .unowned:
            return "Непонятно"
        }
    }
}
