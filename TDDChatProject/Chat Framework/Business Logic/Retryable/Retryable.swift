//
//  Retryable.swift
//  TDDChatProject
//
//  Created by Mendy Edri on 01/01/2020.
//  Copyright © 2020 CWT. All rights reserved.
//

import Foundation

public protocol Retryable {
    init?(attempts: Int, action: (() -> Void)?)
    
    func setAction(_ action: @escaping () -> Void)
    func reset()
    
    @discardableResult
    func retry() -> Bool
}

extension Retryable {
    init?(attempts: Int) {
        self.init(attempts: attempts, action: nil)
    }
}
