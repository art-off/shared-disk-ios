//
//  StartProjectView.swift
//  shared-disk
//
//  Created by Artem Rylov on 02.06.2021.
//

import SwiftUI

struct StartProjectView: View {
    
    @State var projName = ""
    
    @State var deadline = Date()
    
    @State var customers: [Cusromer] = []
    @State var selectedCustomerId = 0
    
    @State var workers: [Worker] = []
    @State var presentSheet = false
    @State var tappedStage = 0
    @State var tasks: [[DevelopmentTask]] = [[], [], []]
    
    
    var body: some View {
        VStack {
            TextField("Название проекта", text: $projName)
            
            DatePicker("Дата завершения", selection: $deadline, displayedComponents: .date)
            
            Picker("Загазчик", selection: $selectedCustomerId) {
                ForEach(customers) { curtomer in
                    Text(curtomer.email + " | " + curtomer.last_name).tag(curtomer.id)
                }
            }
            
            HStack {
                Text("Добавить задачи по дизайну")
                Button(action: {
                    tappedStage = 0
                    presentSheet = true
                }) {
                    Image(systemName: "plus")
                }
                Spacer()
            }
            HStack {
                Text("Добавить задачи по разработке")
                Button(action: {
                    tappedStage = 1
                    presentSheet = true
                }) {
                    Image(systemName: "plus")
                }
                Spacer()
            }
            HStack {
                Text("Добавить задачи по тестированию")
                Button(action: {
                    tappedStage = 2
                    presentSheet = true
                }) {
                    Image(systemName: "plus")
                }
                Spacer()
            }
            
            Button("Начать проект") {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                let stages = [
                    DevelopmentStage(type: 1, tasks: tasks[0]),
                    DevelopmentStage(type: 2, tasks: tasks[1]),
                    DevelopmentStage(type: 3, tasks: tasks[2]),
                ]
                .filter { !$0.tasks.isEmpty }
                
                MyAPIServic().startProject(
                    project: Project(
                        name: projName,
                        deadline: dateFormatter.string(from: deadline),
                        customer: customers.first { $0.id == selectedCustomerId }!,
                        managerId: UserStorage.id,
                        developmentStages: stages),
                    completion: { result in
                        print(result)
                    }
                )
            }
            .padding(.top)
            
            Spacer()
        }
        .padding()
        .onAppear {
            MyAPIServic().getCustomers(completion: { customers in
                guard let c = customers else { return }
                self.customers = c
            })
            MyAPIServic().getWorkers(completion: { workers in
                guard let w = workers else { return }
                self.workers = w
            })
        }
        .sheet(isPresented: $presentSheet) {
            SetDevelopmentStageView(tasks: $tasks, workers: workers, professionType: tappedStage)
        }
    }
}


struct SetDevelopmentStageView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var presentSheet = false
    
    @Binding var tasks: [[DevelopmentTask]]
    @State var workers: [Worker]
    @State var professionType: Int
    
    @State var taskName = ""
    @State var selectedWorkerId = 0
    
    var filWorkers: [Worker] {
        dump(workers)
        return workers.filter { $0.professionType == professionType + 1 }
    }
    
    func stageName(type: Int) -> String {
        let dict = [
            0: "Дизайн",
            1: "Разработка",
            2: "Тестирование",
        ]
        return dict[type] ?? "Неопозн"
    }
    
    var body: some View {
        VStack {
//            Text(stageName(professionType))
            Button("Закрыть") {
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
            
            ForEach(tasks[professionType], id: \.name) { task in
                HStack {
                    Text(task.name + " -> " + task.worker.name)
                    Spacer()
                    Button("Удалить") {
                        tasks[professionType].removeAll(where: { $0.name == task.name })
                    }
                }
            }
            
            Spacer()
            TextField("Название задачи", text: $taskName)
            Picker("Исполнитель", selection: $selectedWorkerId) {
                ForEach(filWorkers) { worker in
                    Text(worker.name).tag(worker.id)
                }
            }
            
            Button(action: {
                guard !taskName.isEmpty, selectedWorkerId != 0 else { return }
                tasks[professionType].append(DevelopmentTask(
                                name: taskName,
                                worker: workers.first { $0.id == selectedWorkerId }!,
                                ready: false)
                )
            }) {
                Text("Добавить")
            }
        }
        .frame(width: 500, height: 500)
        .padding()
    }
}

//private struct AddTaskView: View {
//    @Environment(\.presentationMode) var presentationMode
//
//
//    @Binding var tasks: [DevelopmentTask]
//    @State var workers: [Worker]
//
//    @State var taskName = ""
//    @State var selectedWorkerId = 0
//
//    var body: some View {
//        VStack {
//            Button("Закрыть") {
//                presentationMode.wrappedValue.dismiss()
//            }
//            .padding()
//
//            TextField("Название задачи", text: $taskName)
//            Picker("Исполнитель", selection: $selectedWorkerId) {
//                ForEach(workers) { worker in
//                    Text(worker.name).tag(worker.id)
//                }
//            }
//
//            Button(action: {
//                guard !taskName.isEmpty, selectedWorkerId != 0 else { return }
//                tasks.append(DevelopmentTask(
//                                name: taskName,
//                                worker: workers.first { $0.id == selectedWorkerId }!,
//                                ready: false)
//                )
//                presentationMode.wrappedValue.dismiss()
//            }) {
//                Text("Добавить")
//            }
//        }
//        .frame(width: 400, height: 200)
//        .padding()
//    }
//}



struct StartProjectView_Previews: PreviewProvider {
    static var previews: some View {
        StartProjectView()
    }
}
