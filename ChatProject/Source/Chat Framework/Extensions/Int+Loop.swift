//
//  Int+Loop.swift
//  ChatProject
//
//  Created by Mendy Edri on 29/01/2020.
//  Copyright © 2020 CWT. All rights reserved.
//

import Foundation

extension Int {
    public func loop(_ action: () -> Void) {
        for _ in 0...self {
            action()
        }
    }
    
    public func loop(_ action: (Int) -> Void) {
        for index in 0...self {
            action(index)
        }
    }
}
