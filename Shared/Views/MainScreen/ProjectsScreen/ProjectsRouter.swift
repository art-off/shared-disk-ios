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
             folder(String, String, Int?)
    }
    
    var body: some View {
        switch currScreen {
        case .projects:
            AnyView(ProjectsView(goToFolder: goToFolder(folderId:folderName:taskId:), goToTask: goToTasks(_:)))
        case .tasks(let tasks):
            AnyView(TasksView(goToFolder: goToFolder(folderId:folderName:taskId:), tasks: tasks))
        case .folder(let (i, n, task_id)):
            AnyView(FolderView(taskId: task_id, folderHistory: [(n, i)]))
        }
    }
    
    func goToProjects() {
        withAnimation {
            currScreen = .projects
        }
    }
    
    func goToFolder(folderId: String, folderName: String, taskId: Int?) {
        withAnimation {
            currScreen = .folder(folderId, folderName, taskId)
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
