//
//  MainNavigatoinView.swift
//  shared-disk
//
//  Created by Artem Rylov on 30.05.2021.
//

import SwiftUI

struct MainNavigatoinView: View {
    
    var goToAuthScreens: () -> Void
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: ProfileView(goToAuthScreens: goToAuthScreens)) {
                    Text("Аккаунт")
                }
                NavigationLink(destination: FolderView(taskId: nil, folderHistory: [("root", "root")])) {
                    Text("Диск")
                }
                NavigationLink(destination: ProjectsRouter()) {
                    Text("Проекты")
                }
                NavigationLink(destination: MessagesView()) {
                    Text("Сообщения")
                }
                if UserStorage.isManager {
                    NavigationLink(destination: StartProjectView()) {
                        Text("Старт проекта")
                    }
                    NavigationLink(destination: RegistrationView(showBask: false, routedCurrScreen: .constant(.registration))) {
                        Text("+ работник")
                    }
                }
            }
            .listStyle(SidebarListStyle())
        }
    }
}

struct MainNavigatoinView_Previews: PreviewProvider {
    static var previews: some View {
        MainNavigatoinView(goToAuthScreens: { })
    }
}
