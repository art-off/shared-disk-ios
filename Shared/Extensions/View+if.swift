//
//  View+if.swift
//  shared-disk
//
//  Created by Artem Rylov on 28.05.2021.
//

import SwiftUI

extension View {
    
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
