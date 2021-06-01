//
//  FolderView.swift
//  shared-disk
//
//  Created by Artem Rylov on 31.05.2021.
//

import SwiftUI

typealias Folder = (name: String, id: String)

struct FolderView: View {
    
    @State var selectedFileID = ""
    
    @State var actionOnSheet: (String) -> Void = { _ in }
    @State var presentSheet = false
    
    @State var files: [FileItem] = []
    
    @State var folderHistory: [Folder]
    
    @State var showAlert = false
    @State var alertText = ""
    
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
                                    updateFiles(folder: (file.name, file.id))
                                } else {
                                    selectedFileID = file.id
                                }
                            }
                            .contextMenu(ContextMenu(menuItems: {
                                Text(file.name)
                                Button("Удалить") {
                                    GoogleDriveService().deleteFile(fileID: file.id) { result in
                                        // mne vse ravno ya pank
                                        updateFiles()
                                    }
                                }
                            }))
    //                        .onDrag { NSItemProvider(object: URL(string: "https://apple.com")! as NSURL) }
                        }
                    }
                    .padding()
                }
            }
            .onDrop(of: [.fileURL], delegate: FileDropDelegate(folderName: folderHistory.last!.id, afterUpload: updateFiles))
            .onAppear {
                updateFiles(folder: folderHistory.last!, notAddnotRemove: true)
            }
            .contextMenu(ContextMenu(menuItems: {
                Button("Создать папку") {
                    actionOnSheet = { name in
                        print(name)
                        GoogleDriveService().createFile(
                            name: name,
                            mimeType: .folder,
                            folderID: folderHistory.last!.id,
                            completion: { result in
                                print(result)
                                updateFiles()
                            }
                        )
                    }
                    presentSheet = true
                }
            }))
        }
        .sheet(isPresented: $presentSheet) {
            SheetView(action: $actionOnSheet)
        }
    }
    
    private func updateFiles() {
        updateFiles(folder: folderHistory.last!, notAddnotRemove: true)
    }
    
    private func updateFiles(folder: Folder, back: Bool = false, notAddnotRemove: Bool = false) {
        print("FINE1")
        GoogleDriveService().files(in: folder.id) { result in
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
    
    let folderName: String
    let afterUpload: () -> Void
    
    func performDrop(info: DropInfo) -> Bool {
        guard info.hasItemsConforming(to: [.fileURL]) else {
            return false
        }
        
        let items = info.itemProviders(for: [.fileURL])
        for item in items {
            _ = item.loadObject(ofClass: URL.self) { url, _ in
                print(url)
                GoogleDriveService().uploadFile(fileUrl: url!, folderID: folderName) { result in
                    print(result)
                    afterUpload()
                }
            }
        }
        
        return true
    }
}



struct SheetView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var action: (String) -> Void
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


struct FolderView_Previews: PreviewProvider {
    static var previews: some View {
        FolderView(folderHistory: [("name", "root")])
    }
}
