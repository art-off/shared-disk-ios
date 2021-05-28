//
//  ContentView.swift
//  Shared
//
//  Created by Artem Rylov on 22.05.2021.
//

import SwiftUI

struct ContentView: View {
    
    @State var files: [FileItem] = [
        FileItem(id: "sdlfkj", name: "ff", mineType: .csv1),
        FileItem(id: "sdlasdffkj", name: "ffffsdfasdfasdfsa", mineType: .csv1),
        FileItem(id: "sdsdddlfkj", name: "ff", mineType: .csv1),
        FileItem(id: "sdlvxcvfkj", name: "ff", mineType: .csv1),
        FileItem(id: "sdwwwlfkj", name: "ff", mineType: .csv1),
    ]
    
    var body: some View {
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
                            .onTapGesture {
                                UserStorage.myToken = ""
                            }
                        Text(file.name)
                            .lineLimit(2)
                        Spacer()
                    }
                }
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
