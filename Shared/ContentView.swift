//
//  ContentView.swift
//  Shared
//
//  Created by Artem Rylov on 22.05.2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("hello")
                .padding()
        }
        .onAppear {
            GoogleDriveService().files(completion: { a in
                dump(a)
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
