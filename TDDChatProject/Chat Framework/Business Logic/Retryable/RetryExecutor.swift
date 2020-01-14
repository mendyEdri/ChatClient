//
//  RetryCommand.swift
//  TDDChatProject
//
//  Created by Mendy Edri on 22/12/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import Foundation

public class RetryExecutor: Retryable {
        
    private var attempts = 0
    var maxAttampts: Int
    var action: (() -> Void)?
    
    public required init?(attempts: Int, action: (() -> Void)? = nil) {
        guard attempts > 0 else { return nil }
        self.maxAttampts = attempts
        self.action = action
    }
    
    public func setAction(_ action: @escaping () -> Void) {
        self.action = action
    }
    
    public func reset() {
        attempts = 0
    }
    
    @discardableResult
    public func retry() -> Bool {
        guard canRetry() == true else { return false }
        retried()
        action?()
        
        return true
    }
    
    // Mark: Helpers

    private func canRetry() -> Bool {
        return attempts < maxAttampts
    }
    
    private func retried() {
        attempts += 1
    }
}

