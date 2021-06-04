//
//  RegistrationView.swift
//  shared-disk (iOS)
//
//  Created by Artem Rylov on 24.05.2021.
//

import SwiftUI

struct RegistrationView: View {
    
    var showBask: Bool
    @Binding var routedCurrScreen: AuthRouter.Screen
    
    @State var selecredProfessionId: Int = 0
    
    @State var isLoading = false
    @State var isAlerting = false
    @State var alertText = ""
    
    @State var login = ""
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        AlertingView(isShowing: $isAlerting, alertText: $alertText) {
            LoadingView(isShowing: $isLoading) {
                VStack {
                    if showBask {
                        HStack {
                            Button("Back", action: {
                                withAnimation {
                                    routedCurrScreen = .auth
                                }
                            })
                            .padding()
                            
                            Spacer()
                        }
                    }
                    Text("Shared disk")
                        .font(.largeTitle)
                        .padding([.top, .bottom], 40)
                    
                    VStack {
                        TextField("Login", text: $login)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding()
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(radius: 5)
                            .padding(.bottom, 16)
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
                    .padding()
                    
                    Picker("Загазчик", selection: $selecredProfessionId) {
                        Text("Дизайнер").tag(1)
                        Text("Разработчик").tag(2)
                        Text("Тестировщик").tag(3)
                    }
                    .padding()
                    
                    Button(action: {
                        guard !login.isEmpty ||
                                !password.isEmpty ||
                                !email.isEmpty
                        else { return }
                        
                        isLoading = true
                        
                        MyAPIServic().registrationWorker(
                            name: login,
                            email: email,
                            password: password,
                            professtionId: selecredProfessionId,
                            completion: { text in
                                self.login = ""
                                self.password = ""
                                self.email = ""
                                self.isLoading = false
                                self.alertText = text
                                self.isAlerting = true
                            }
                        )
                    }) {
                        Text("Registration")
                            .font(.headline)
                            .frame(width: 250, height: 50)
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(radius: 10)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(showBask: true, routedCurrScreen: .constant(.registration))
    }
}
