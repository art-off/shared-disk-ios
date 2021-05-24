//
//  AuthRouter.swift
//  shared-disk (iOS)
//
//  Created by Artem Rylov on 24.05.2021.
//

import SwiftUI

struct AuthRouter: View {
    
    @State var currScreen: Screen = .auth
    
    enum Screen {
        case auth,
             registration
    }
    
    var body: some View {
        ScrollView {
            switch currScreen {
            case .auth:
                #if os(macOS)
                AnyView(AuthView(routedCurrScreen: $currScreen))
                    .frame(width: 800, height: 400)
                    .transition(.back)
                #else
                AnyView(AuthView(routedCurrScreen: $currScreen))
                    .transition(.back)
                #endif
            case .registration:
                #if os(macOS)
                AnyView(RegistrationView(routedCurrScreen: $currScreen))
                    .frame(width: 800, height: 400)
                    .transition(.go)
                #else
                AnyView(RegistrationView(routedCurrScreen: $currScreen))
                    .transition(.go)
                #endif
            }
        }
    }
}

struct AuthRouter_Previews: PreviewProvider {
    static var previews: some View {
        AuthRouter()
    }
}
