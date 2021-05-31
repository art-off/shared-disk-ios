//
//  UserStorage.swift
//  shared-disk (iOS)
//
//  Created by Artem Rylov on 24.05.2021.
//

import SwiftUI

class UserStorage {
    
    @AppStorage("login") static var login: String = ""
    @AppStorage("email") static var email: String = ""
    @AppStorage("my-token") static var myToken: String = ""
    @AppStorage("google-token") static var googleToken: String = ""
    
    static func clear() {
        login.removeAll()
        email.removeAll()
        myToken.removeAll()
        googleToken.removeAll()
    }
}
