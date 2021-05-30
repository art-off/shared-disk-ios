//
//  FolderView.swift
//  shared-disk
//
//  Created by Artem Rylov on 31.05.2021.
//

import SwiftUI

struct FolderView: View {
    
    @State var files: [FileItem] = [
        FileItem(id: "sdlfkj", name: "ff", mineType: .csv1),
        FileItem(id: "sdlasdffkj", name: "ffffsdfasdfasdfsa", mineType: .csv1),
        FileItem(id: "sdsdddlfkj", name: "ff", mineType: .csv1),
        FileItem(id: "sdlvxcvfkj", name: "ff", mineType: .csv1),
        FileItem(id: "sdwwwlfkj", name: "ff", mineType: .csv1),
    ]
    
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
                    }
                }
                .padding()
            }
            .onAppear {
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
    }
}

struct FolderView_Previews: PreviewProvider {
    static var previews: some View {
        FolderView(folderName: "root")
    }
}
