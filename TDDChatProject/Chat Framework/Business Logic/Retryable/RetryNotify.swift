//
//  RetryNotify.swift
//  TDDChatProject
//
//  Created by Mendy Edri on 01/01/2020.
//  Copyright © 2020 CWT. All rights reserved.
//

import Foundation

public class RetryNotify: Retryable {
    
    private var attempts = 0
    var maxAttampts: Int
    var action: (() -> Void)?
    public var onRetry: (() -> Void)?
    
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
        onRetry?()
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
