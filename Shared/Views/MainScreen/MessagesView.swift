//
//  MessagesView.swift
//  shared-disk (iOS)
//
//  Created by Artem Rylov on 04.06.2021.
//

import SwiftUI

struct MessagesView: View {
    
    @State var messages: [MessageResponse] = []
    
    
    var messagesForShow: [MessageResponse] {
        if UserStorage.isManager {
            return messages
        } else {
            return messages.filter { !$0.project_finish }
        }
    }
    
    var body: some View {
        List(messages) { message in
            VStack(alignment: .leading) {
                Text(message.project_name!).bold()
                Text("\(message.stage_name!),") +
                    Text(message.task_name!).bold() +
                    Text("(\(message.worker_email))")
                
                Text(message.text)
                    .padding(.top)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .border(Color.red)
        }
        .onAppear {
            MyAPIServic().getMessages { result in
                switch result {
                case .failure(let e):
                    print("ERORRR", e)
                case .success(let r):
                    self.messages = r.sorted(by: { $0.id > $1.id })
                    print(self.messages)
                }
            }
        }
    }
}

struct MessagesView_Previews: PreviewProvider {
    
    static var previews: some View {
        MessagesView()
    }
}
