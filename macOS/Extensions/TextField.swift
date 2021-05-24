//
//  TextField.swift
//  shared-disk (iOS)
//
//  Created by Artem Rylov on 24.05.2021.
//

import AppKit

extension NSTextField {
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set { }
    }
}
