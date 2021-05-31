//
//  AuthView.swift
//  shared-disk (iOS)
//
//  Created by Artem Rylov on 24.05.2021.
//

import SwiftUI

struct AuthView: View {
    
    var goToGeneral: () -> Void
    @Binding var routedCurrScreen: AuthRouter.Screen
    
    @State var email = ""
    @State var password = ""
    
    @State var alertingText = ""
    @State var showAlert = false
    
    var body: some View {
        AlertingView(isShowing: $showAlert, alertText: $alertingText) {
            VStack {
                Text("Shared disk")
                    .font(.largeTitle)
                    .padding([.top, .bottom], 40)
                Image("cloud")
                    .resizable()
                    .frame(width: 250, height: 200)
                    .padding(.bottom, 50)
                
                VStack {
                    TextField("Email", text: $email)
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
                
                Button(action: {
                    guard !email.isEmpty && !password.isEmpty else { return }
                    
                    MyAPIServic().auth(
                        email: email,
                        password: password,
                        completion: { fine in
                            guard fine else {
                                alertingText = "Не удалось зайти"
                                showAlert = true
                                return
                            }
                            goToGeneral()
                        }
                    )
                }) {
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
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView(goToGeneral: {}, routedCurrScreen: .constant(.auth))
    }
}
