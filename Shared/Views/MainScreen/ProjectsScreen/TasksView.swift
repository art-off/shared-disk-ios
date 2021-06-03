//
//  TasksView.swift
//  shared-disk (iOS)
//
//  Created by Artem Rylov on 03.06.2021.
//

import SwiftUI

struct TasksView: View {
    
    let goToFolder: (String, String) -> Void
    
    @State var tasks: [TaskResponse]
    
    var body: some View {
        List(tasks) { task in
            VStack(alignment: .leading) {
                Text(task.name).bold()
                Text(task.ready ? "Готов" : "Не готов")
                if task.worker.id == UserStorage.id {
                    Button("Директория для работы") {
                        goToFolder(task.folder_id, task.name)
                    }
                    Button("Директория для заказчика") {
                        goToFolder(task.customer_folder_id, task.name)
                    }
                } else {
                    Button("Финальная директория") {
                        goToFolder(task.finally_folder_id, task.name)
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
//            let id: Int
//            let name: String
//            let ready: Bool
//            let customer_folder_id: String
//            let finally_folder_id: String
//            let worker: WorkerResopnse
        }
    }
}

struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        TasksView(goToFolder: { _, _ in }, tasks: [])
    }
}
