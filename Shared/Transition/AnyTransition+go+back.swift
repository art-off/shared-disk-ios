//
//  AnyTransition+go+back.swift
//  shared-disk (iOS)
//
//  Created by Artem Rylov on 24.05.2021.
//

import SwiftUI

extension AnyTransition {
    
    static var go: AnyTransition {
        .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))
    }
    
    static var back: AnyTransition {
        .asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing))
    }
}
