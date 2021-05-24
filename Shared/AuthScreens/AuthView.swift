//
//  AuthView.swift
//  shared-disk (iOS)
//
//  Created by Artem Rylov on 24.05.2021.
//

import SwiftUI

struct AuthView: View {
    
    @Binding var routedCurrScreen: AuthRouter.Screen
    
    @State var login = ""
    @State var password = ""
    
    var body: some View {
        VStack {
            Text("Shared disk")
                .font(.largeTitle)
                .padding([.top, .bottom], 40)
            Image("cloud")
                .resizable()
                .frame(width: 250, height: 200)
                .padding(.bottom, 50)
            
            VStack {
                TextField("Login", text: $login)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 5)
                    .padding(.bottom, 16)
                SecureField("Password", text: $password)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 5)
            }
            .padding([.leading, .trailing], 20)
            
            Button(action: { }) {
                Text("Sign In")
                    .font(.headline)
                    .frame(width: 250, height: 50)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 10)
            }
            .buttonStyle(PlainButtonStyle())
            .padding()
            
            Button(action: {
                withAnimation {
                    routedCurrScreen = .registration
                }
            }) {
                Text("Registration")
            }
            
            Spacer()
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView(routedCurrScreen: .constant(.auth))
    }
}
