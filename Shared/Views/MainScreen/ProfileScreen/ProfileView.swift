//
//  ProfileView.swift
//  shared-disk (iOS)
//
//  Created by Artem Rylov on 31.05.2021.
//

import SwiftUI

struct ProfileView: View {
    
    @Environment(\.openURL) var openURL
    
    var goToAuthScreens: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(UserStorage.login)
                        .block()
                    
                    Text(UserStorage.email)
                        .block()
                }
                Spacer()
                Button("Sign Out") {
                    UserStorage.clear()
                    goToAuthScreens()
                }
            }
            .padding()
            
            Button("Обновить разрешение Google Drive") {
                GoogleDriveService().refreshToken { result in
                    switch result {
                    case .failure(let error):
                        print(error)
                        break
                    case .success(let url):
                        openURL(url)
                    }
                }
            }
            .padding([.leading, .top])
            
            Button("Получить новый токен Google Drive") {
                GoogleDriveService().authGoogleDrive { result in
                    switch result {
                    case .failure(let error):
                        print(error)
                        break
                    case .success(_):
                        break
                    }
                }
            }
            .padding(.leading)
            
            Spacer()
        }
    }
}

private extension Text {
    func block() -> some View {
        self
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 4)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(goToAuthScreens: { })
    }
}
