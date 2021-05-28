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
    
    case unowned
    
    
    init(stringError: String) {
        switch stringError {
        case "password_too_short":
            self = .passwordToShort
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
        case .unowned:
            return "Непонятно"
        }
    }
}
