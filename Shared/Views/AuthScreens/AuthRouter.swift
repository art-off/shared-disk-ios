//
//  AuthRouter.swift
//  shared-disk (iOS)
//
//  Created by Artem Rylov on 24.05.2021.
//

import SwiftUI

struct AuthRouter: View {
    
    @Binding var topRouterScreen: FirstRouter.Screen
    @State var currScreen: Screen = .auth
    
    enum Screen {
        case auth,
             registration
    }
    
    var body: some View {
        ScrollView {
            switch currScreen {
            case .auth:
                AnyView(AuthView(goToGeneral: goToGeneral, routedCurrScreen: $currScreen))
                    .transition(.back)
            case .registration:
                AnyView(RegistrationView(routedCurrScreen: $currScreen))
                    .transition(.go)
            }
        }
    }
    
    func goToGeneral() {
        withAnimation {
            topRouterScreen = .generalScreen
        }
    }
}

struct AuthRouter_Previews: PreviewProvider {
    static var previews: some View {
        AuthRouter(topRouterScreen: .constant(.authScreen))
    }
}
