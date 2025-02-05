//
//  FolderView.swift
//  shared-disk
//
//  Created by Artem Rylov on 31.05.2021.
//

import SwiftUI

typealias Folder = (name: String, id: String)

enum ActiveSheet: Identifiable {
    case createFodler((String) -> Void),
         fileInfo(String)
    
    var id: Int {
        switch self {
        case .createFodler(_):
            return 1
        case .fileInfo(_):
            return 2
        }
    }
}

struct FolderView: View {
    
    let taskId: Int?
    
    @State var selectedFileID = ""
    
//    @State var actionOnSheet: (String) -> Void = { _ in }
    @State var activeSheet: ActiveSheet?
//    @State var presentCreateFolderSheet = false
//    @State var presentShowInfoSheet = false
    
    @State var files: [FileItem] = []
    
    @State var folderHistory: [Folder]
    
    @State var showAlert = false
    @State var alertText = ""
    
    
    @State var workers: [Worker] = []
    
    
    var body: some View {
        AlertingView(isShowing: $showAlert, alertText: $alertText) {
            ScrollView {
                
                VStack {
                    ZStack {
                        HStack {
                            if folderHistory.count > 1 {
                                let previousFolder = folderHistory[folderHistory.count - 2]
                                Button("< " + previousFolder.name) {
                                    updateFiles(folder: previousFolder, back: true)
                                }
                                Spacer()
                            }
                        }
                        Text(folderHistory.last!.name)
                            .font(.title)
                    }
                    .padding()
                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: 90))],
                        alignment: .center,
                        spacing: 16
                    ) {
                        ForEach(files) { file in
                            VStack {
                                file.mineType.image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 50)
                                Text(file.name)
                                    .lineLimit(2)
                                Spacer()
                            }
                            .padding()
                            .if(selectedFileID == file.id) { view in
                                view
                                    .background(Color.gray.opacity(0.3))
                                    .cornerRadius(10)
                            }
                            .onTapGesture {
                                if selectedFileID == file.id {
                                    if file.mineType == .folder {
                                        updateFiles(folder: (file.name, file.id))
                                    } else {
                                        // TODO: Сделать открытие инфв о файле (сколько занимает и изменения файлов)
//                                        presentShowInfoSheet = true
                                        activeSheet = .fileInfo(selectedFileID)
                                    }
                                } else {
                                    selectedFileID = file.id
                                }
                            }
                            .contextMenu(ContextMenu(menuItems: {
                                Text(file.name)
                                Button("Удалить") {
//                                    GoogleDriveService().deleteFile(taskId: taskId,
//                                                                    isFolder: file.mimeType == .folder,
//                                                                    fileName: file.name,
//                                                                    fileID: file.id) { result in
//                                        // mne vse ravno ya pank
//                                        updateFiles()
//                                    }
                                    GoogleDriveService().deleteFile(
                                        taskId: taskId,
                                        isFolder: file.mineType == .folder,
                                        fileName: file.name,
                                        fileID: file.id,
                                        completion: { result in
                                            updateFiles()
                                        })
                                }
                                Button("Скачать") {
                                    GoogleDriveService().donwloadFile(name: file.name, fileID: file.id, mimeType: file.mineType.stringType) { result in
                                        // mne vse ravno ya pank
                                    }
                                }
                                if UserStorage.isManager {
                                    ForEach(workers) { worker in
                                        Button("- Дать доступ работнику '" + worker.name + "'") {
                                            GoogleDriveService().givePermission(fileID: file.id, userEmail: worker.email) { result in
                                                print(result)
                                            }
                                        }
                                    }
                                }
                            }))
                        }
                    }
                    .padding()
                }
            }
            .onDrop(of: [.fileURL], delegate: FileDropDelegate(taskId: taskId, filesList: files, folderName: folderHistory.last!.id, afterUpload: updateFiles))
            .onAppear {
                print("TASK ID", taskId)
                updateFiles(folder: folderHistory.last!, notAddnotRemove: true)
                MyAPIServic().getWorkers(completion: { workers in
                    guard let w = workers else { return }
                    self.workers = w
                })
            }
            .contextMenu(ContextMenu(menuItems: {
                Button("Создать папку") {
//                    actionOnSheet = { name in
//                        GoogleDriveService().createFile(
//                            taskId: taskId,
//                            name: name,
//                            mimeType: .folder,
//                            folderID: folderHistory.last!.id,
//                            completion: { result in
//                                print(result)
//                                updateFiles()
//                            }
//                        )
//                    }
                    activeSheet = .createFodler({ name in
                        GoogleDriveService().createFile(
                            taskId: taskId,
                            name: name,
                            mimeType: .folder,
                            folderID: folderHistory.last!.id,
                            completion: { result in
                                print(result)
                                updateFiles()
                            }
                        )
                    })
                }
            }))
        }
        .sheet(item: $activeSheet) { item in
            switch item {
            case .createFodler(let a):
                SheetView(action: a)
            case .fileInfo(let a):
                FileInfoSheetView(fileID: a)
            }
        }
//        .sheet(isPresented: $activeSheet) {
//            FileInfoSheetView(fileID: $selectedFileID)
//        }
//        .sheet(isPresented: $activeSheet) {
//            SheetView(action: $actionOnSheet)
//        }
    }
    
    private func updateFiles() {
        updateFiles(folder: folderHistory.last!, notAddnotRemove: true)
    }
    
    private func updateFiles(folder: Folder, back: Bool = false, notAddnotRemove: Bool = false) {
        print("FINE1")
        GoogleDriveService().files(taskId: taskId, folderName: folder.name, in: folder.id) { result in
            switch result {
            case .failure(let error):
                alertText = error.description
                showAlert = true
            case .success(let fileItems):
                files = fileItems
                guard !notAddnotRemove else { return }
                if back {
                    folderHistory.removeLast()
                } else {
                    folderHistory.append(folder)
                }
            }
        }
    }
}

struct FileDropDelegate: DropDelegate {
    
    let taskId: Int?
    let filesList: [FileItem]
    let folderName: String
    let afterUpload: () -> Void
    
    func performDrop(info: DropInfo) -> Bool {
        guard info.hasItemsConforming(to: [.fileURL]) else {
            return false
        }
        
        let items = info.itemProviders(for: [.fileURL])
        for item in items {
            _ = item.loadObject(ofClass: URL.self) { url, _ in
                let updateFile = filesList.first { $0.name == url!.lastPathComponent }
                if let updateFile = updateFile {
                    GoogleDriveService().updateFile(taskId: taskId, fileUrl: url!, fileID: updateFile.id) { result in
                        print(result)
                        afterUpload()
                    }
                } else {
                    GoogleDriveService().uploadFile(taskId: taskId, fileUrl: url!, folderID: folderName) { result in
                        print(result)
                        afterUpload()
                    }
                }
            }
        }
        
        return true
    }
}



struct SheetView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var action: (String) -> Void
    @State var name = ""

    var body: some View {
        HStack(alignment: .top) {
            TextField("Название", text: $name)
            VStack {
                Button("Создать") {
                    guard !name.isEmpty else { return }
                    action(name)
                    presentationMode.wrappedValue.dismiss()
                }
                Button("Отменить") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .frame(width: 300)
        .padding()
    }
}

struct FileInfoSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var fileID: String
    
    @State var revisionList: [FileRevision] = []
    
    let dateFormatter1: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return df
    }()
    
    let dateFormatter2: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yy HH:mm"
        return df
    }()
    
    private func getStringDate(date: String) -> String {
        let d = dateFormatter1.date(from: String(date.prefix(19)))!
        return dateFormatter2.string(from: d)
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Изменения файла")
                Spacer()
                Button("Закрыть") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .padding()
            List {
                ForEach(revisionList) { revision in
                    HStack {
                        Text(revision.fileName)
                            .if(.macOS) { view in
                                view.frame(width: 95)
                            }
                        Divider()
                        Text(revision.modifiedUser.displayName)
                            .if(.macOS) { view in
                                view.frame(width: 95)
                            }
                        Divider()
                        Text(getStringDate(date: revision.modifiedTime))
                            .if(.macOS) { view in
                                view.frame(width: 95)
                            }
                        Divider()
                        Text(revision.size + " Б")
                            .if(.macOS) { view in
                                view.frame(width: 95)
                            }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                }
            }
        }
        .if(.macOS) { view in
            view.frame(width: 500, height: 500)
        }
        .padding()
        .onAppear {
            GoogleDriveService().fileRevisions(fileID: fileID) { result in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let revisions):
                    revisionList = revisions
                }
            }
        }
    }
}


struct FolderView_Previews: PreviewProvider {
    static var previews: some View {
        FolderView(taskId: nil, folderHistory: [("name", "root")])
    }
}
