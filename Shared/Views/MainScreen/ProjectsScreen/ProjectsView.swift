//
//  ProjectsView.swift
//  shared-disk (iOS)
//
//  Created by Artem Rylov on 03.06.2021.
//

import SwiftUI

struct ProjectsView: View {
    
    let goToFolder: (String, String, Int?) -> Void
    let goToTask: ([TaskResponse]) -> Void
    
    @State var projects: [ProjectResponse] = []
    
    var projectsToShow: [ProjectResponse] {
        if UserStorage.isManager {
            return projects
        } else {
            return projects.filter { !$0.finish }
        }
    }
    
    var body: some View {
        VStack {
            List(projectsToShow) { project in
                VStack(alignment: .leading) {
                    Text(project.name)
                        .bold()
                    if project.finish {
                        Text("Закончен").bold()
                    }
                    Text("Время начала: " + project.start_time)
                    Text("Дедлайн: " + project.deadline)
                    Text("Заказчик: " + project.customer.last_name)
                    Text("Менеджер: " + project.manager.name)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .border(Color.red)
                .contextMenu {
                    if UserStorage.isManager {
                        Button("Закончить") {
                            MyAPIServic().finishWorkOnProject(project_id: project.id, completion: { result in
                                print(result)
                            })
                        }
                        Button("Открыть папку проекта") {
                            goToFolder(project.folder_id, project.name, nil)
                        }
                    }
                    
                    Button("Открыть задачи") {
                        let tasks = project.stages.flatMap {
                            $0.tasks
                        }
                        print(tasks)
                        goToTask(tasks)
                    }
                }
            }
        }
        .onAppear {
            MyAPIServic().getProjects { result in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let proj):
                    self.projects = proj
                }
            }
        }
    }
}

struct ProjectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectsView(goToFolder: { _, _, _  in }, goToTask: { _ in })
    }
}
