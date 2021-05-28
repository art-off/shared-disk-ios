//
//  Bool.swift
//  shared-disk
//
//  Created by Artem Rylov on 28.05.2021.
//

import Foundation

extension Bool {
    
    static var macOS: Bool {
        #if os(macOS)
        return true
        #else
        return false
        #endif
    }
}
