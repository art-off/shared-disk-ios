//
//  ProjectsRouter.swift
//  shared-disk (iOS)
//
//  Created by Artem Rylov on 03.06.2021.
//

import SwiftUI

struct ProjectsRouter: View {
    
    @State var currScreen: Screen = .projects
    
    enum Screen {
        case projects,
             tasks([TaskResponse]),
             folder(String, String)
    }
    
    var body: some View {
        switch currScreen {
        case .projects:
            AnyView(ProjectsView(goToFolder: goToFolder(folderId:folderName:), goToTask: goToTasks(_:)))
        case .tasks(let tasks):
            AnyView(TasksView(goToFolder: goToFolder(folderId:folderName:), tasks: tasks))
        case .folder(let (i, n)):
            AnyView(FolderView(folderHistory: [(n, i)]))
        }
    }
    
    func goToProjects() {
        withAnimation {
            currScreen = .projects
        }
    }
    
    func goToFolder(folderId: String, folderName: String) {
        withAnimation {
            currScreen = .folder(folderId, folderName)
        }
    }
    
    func goToTasks(_ tasks: [TaskResponse]) {
        withAnimation {
            currScreen = .tasks(tasks)
        }
    }
}

struct ProjectsRouter_Previews: PreviewProvider {
    static var previews: some View {
        ProjectsRouter()
    }
}
