//
//  TasksView.swift
//  shared-disk (iOS)
//
//  Created by Artem Rylov on 03.06.2021.
//

import SwiftUI

struct TasksView: View {
    
    let goToFolder: (String, String, Int?) -> Void
    
    @State var tasks: [TaskResponse]
    
    var body: some View {
        List(tasks) { task in
            VStack(alignment: .leading) {
                Text(task.name).bold()
                Text(task.ready ? "Готов" : "Не готов")
                if task.worker.id == UserStorage.id {
                    Button("Директория для работы") {
                        goToFolder(task.folder_id, task.name, task.id)
                    }
                    Button("Директория для заказчика") {
                        goToFolder(task.customer_folder_id, task.name, task.id)
                    }
                } else {
                    Button("Финальная директория") {
                        goToFolder(task.finally_folder_id, task.name, task.id)
                    }
                }
            }
            .onAppear {
                print(UserStorage.id)
                dump(tasks)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .border(Color.red)
        }
    }
}

struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        TasksView(goToFolder: { _, _, _  in }, tasks: [])
    }
}
