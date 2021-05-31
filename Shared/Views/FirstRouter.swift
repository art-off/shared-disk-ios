//
//  FirstRouter.swift
//  shared-disk
//
//  Created by Artem Rylov on 28.05.2021.
//

import SwiftUI

struct FirstRouter: View {
    
    @State var currScreen: Screen
    
    enum Screen {
        case authScreen,
             generalScreen
    }
    
    var body: some View {
        switch currScreen {
        case .authScreen:
            AnyView(AuthRouter(topRouterScreen: $currScreen))
        case .generalScreen:
            AnyView(MainNavigatoinView(goToAuthScreens: {
                withAnimation {
                    currScreen = .authScreen
                }
            }))
                .transition(.opacity)
        }
    }
}

struct FirstRouter_Previews: PreviewProvider {
    static var previews: some View {
        FirstRouter(currScreen: .authScreen)
    }
}
