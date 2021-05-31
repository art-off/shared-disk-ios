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
                NavigationLink(destination: FolderView(folderName: "root")) {
                    Text("Диск")
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
