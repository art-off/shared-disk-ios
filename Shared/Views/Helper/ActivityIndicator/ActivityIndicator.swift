//
//  ActivityIndicator.swift
//  shared-disk (iOS)
//
//  Created by Artem Rylov on 24.05.2021.
//

import SwiftUI

struct ActivityIndicator: View {
    
    @State var text = ""
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Text("Loading \(text)")
            .font(.system(size: 17)).bold()
            .transition(.slide)
            .onReceive(timer, perform: { _ in
                if self.text.count == 3 {
                    self.text = ""
                } else {
                    self.text += "."
                }
            })
            .onAppear {
                self.text = "."
            }
    }
}

struct ActivityIndicator_Previews: PreviewProvider {
    static var previews: some View {
        ActivityIndicator()
    }
}
