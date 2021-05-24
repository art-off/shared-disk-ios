//
//  UserStorage.swift
//  shared-disk (iOS)
//
//  Created by Artem Rylov on 24.05.2021.
//

import SwiftUI

class UserStorage {
    
    @AppStorage("my-token") static var myToken: String = ""
    @AppStorage("google-token") static var googleToken: String = ""
}
