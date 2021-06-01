//
//  FolderView.swift
//  shared-disk
//
//  Created by Artem Rylov on 31.05.2021.
//

import SwiftUI

struct FolderView: View {
    
    @State var actionOnSheet: (String) -> Void = { _ in }
    @State var presentSheet = false
    
    @State var files: [FileItem] = []
    
    @State var folderName: String
    
    @State var showAlert = false
    @State var alertText = ""
    
    var body: some View {
        AlertingView(isShowing: $showAlert, alertText: $alertText) {
            ScrollView {
                LazyVGrid(
                    columns: [GridItem(.adaptive(minimum: 90))],
                    alignment: .center,
                    spacing: 16
                ) {
                    ForEach(files) { file in
                        VStack {
                            Rectangle()
                                .foregroundColor(.red)
                                .aspectRatio(contentMode: .fit)
                            Text(file.name)
                                .lineLimit(2)
                            Spacer()
                        }
                        .contextMenu(ContextMenu(menuItems: {
                            /*@START_MENU_TOKEN@*/Text("Menu Item 1")/*@END_MENU_TOKEN@*/
                            /*@START_MENU_TOKEN@*/Text("Menu Item 2")/*@END_MENU_TOKEN@*/
                            /*@START_MENU_TOKEN@*/Text("Menu Item 3")/*@END_MENU_TOKEN@*/
                        }))
//                        .onDrag { NSItemProvider(object: URL(string: "https://apple.com")! as NSURL) }
                    }
                }
                .padding()
            }
            .onDrop(of: [.fileURL], delegate: FileDropDelegate(folderName: folderName, afterUpload: updateFiles))
            .onAppear {
                updateFiles()
            }
            .contextMenu(ContextMenu(menuItems: {
                Button("Создать папку") {
                    actionOnSheet = { name in
                        print(name)
                        GoogleDriveService().createFile(
                            name: name,
                            mimeType: .folder,
                            folderID: folderName,
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
        GoogleDriveService().files(in: folderName) { result in
            switch result {
            case .failure(let error):
                alertText = error.description
                showAlert = true
            case .success(let fileItems):
                files = fileItems
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
        FolderView(folderName: "root")
    }
}
