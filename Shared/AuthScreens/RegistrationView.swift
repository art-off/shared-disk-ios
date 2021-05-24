//
//  RegistrationView.swift
//  shared-disk (iOS)
//
//  Created by Artem Rylov on 24.05.2021.
//

import SwiftUI

struct RegistrationView: View {
    
    @Binding var routedCurrScreen: AuthRouter.Screen
    
    @State var login = ""
    @State var password = ""
    
    var body: some View {
        VStack {
            HStack {
                Button("Back", action: {
                    withAnimation {
                        routedCurrScreen = .auth
                    }
                })
                .padding()
                Spacer()
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
                SecureField("Password", text: $password)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 5)
            }
            .padding()
            
            Button(action: { }) {
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

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(routedCurrScreen: .constant(.registration))
    }
}
