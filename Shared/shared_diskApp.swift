//
//  shared_diskApp.swift
//  Shared
//
//  Created by Artem Rylov on 22.05.2021.
//

import SwiftUI

@main
struct shared_diskApp: App {
    var body: some Scene {
        WindowGroup {
            FirstRouter(currScreen: UserStorage.myToken == "" ? .authScreen : .generalScreen)
                .if(.macOS) { view in
                    view.frame(width: 800, height: 700)
                }
        }
    }
}
