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
    
    @State var textMessage = ""
    
    var body: some View {
        List(tasks) { task in
            HStack {
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
                if task.worker.id == UserStorage.id {
                    VStack(alignment: .leading) {
                        if !task.current {
                            Button("Начать работу") {
                                makeTaskCurrent(task: task)
                            }
                        } else {
                            Text("Сообщение о завершении работы")
                            TextEditor(text: $textMessage)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.black, lineWidth: 1)
                                )
                                .frame(width: 350, height: 60)
                            Button("Закончить работу") {
                                finishTask(task: task, finishText: textMessage)
                            }
                        }
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
    
    func makeTaskCurrent(task: TaskResponse) {
        MyAPIServic().startWorkOnTask(taskId: task.id) { result in
            switch result {
            case .failure(let e):
                print("ERRRRO", e)
            case .success(_):
                print("FINE")
                self.tasks = tasks.map {
                    if $0.id == task.id {
                        return TaskResponse(
                            id: $0.id,
                            name: $0.name,
                            ready: $0.ready,
                            current: true,
                            folder_id: $0.folder_id,
                            customer_folder_id: $0.customer_folder_id,
                            finally_folder_id: $0.finally_folder_id,
                            worker: $0.worker
                        )
                    } else {
                        return $0
                    }
                }
            }
        }
    }
    
    func finishTask(task: TaskResponse, finishText: String) {
        MyAPIServic().finishWorkOnTask(taskId: task.id, message: textMessage) { result in
            switch result {
            case .failure(let e):
                print("ERRRRO", e)
            case .success(_):
                print("FINE")
                self.tasks = tasks.map {
                    if $0.id == task.id {
                        return TaskResponse(
                            id: $0.id,
                            name: $0.name,
                            ready: $0.ready,
                            current: false,
                            folder_id: $0.folder_id,
                            customer_folder_id: $0.customer_folder_id,
                            finally_folder_id: $0.finally_folder_id,
                            worker: $0.worker
                        )
                    } else {
                        return $0
                    }
                }
            }
        }
    }
}

struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        TasksView(goToFolder: { _, _, _  in }, tasks: [])
    }
}
