//
//  UserStorage.swift
//  shared-disk (iOS)
//
//  Created by Artem Rylov on 24.05.2021.
//

import SwiftUI

class UserStorage {
    
    @AppStorage("id") static var id = 1
    @AppStorage("login") static var login: String = ""
    @AppStorage("email") static var email: String = ""
    @AppStorage("my-token") static var myToken: String = ""
    @AppStorage("google-token") static var googleToken: String = ""
    @AppStorage("is-manager") static var isManager = false
    
    static func clear() {
        id = 1
        login.removeAll()
        email.removeAll()
        myToken.removeAll()
        googleToken.removeAll()
        isManager = false
    }
}
