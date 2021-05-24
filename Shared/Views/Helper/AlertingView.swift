//
//  AlertingView.swift
//  shared-disk (iOS)
//
//  Created by Artem Rylov on 24.05.2021.
//

import SwiftUI

struct AlertingView<Content>: View where Content: View {

    @Binding var isShowing: Bool
    @Binding var alertText: String
    var content: () -> Content

    var body: some View {
        ZStack(alignment: .center) {
            
            self.content()
            
            if isShowing {
                Text(alertText)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.gray)
                    .cornerRadius(10)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation {
                                self.isShowing = false
                            }
                        }
                    }
            }
        }
    }

}

struct AlertingView_Previews: PreviewProvider {
    static var previews: some View {
        AlertingView(isShowing: .constant(true), alertText: .constant("sldkfjsdf")) {
            EmptyView()
                .frame(width: 200, height: 200)
        }
    }
}
