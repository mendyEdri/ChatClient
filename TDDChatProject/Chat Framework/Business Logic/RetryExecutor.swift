//
//  RetryCommand.swift
//  TDDChatProject
//
//  Created by Mendy Edri on 22/12/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import Foundation

public class RetryExecutor {
    private var retries = 0
    var maxAttampts: Int
    var action: () -> Void
    
    public init?(attempts: Int, action: @escaping () -> Void) {
        guard attempts > 0 else { return nil }
        self.maxAttampts = attempts
        self.action = action
    }
    
    public func reset() {
        retries = 0
    }
    
    @discardableResult
    public func retry() -> Bool {
        guard canRetry() == true else { return false }
        retried()
        action()
        
        return true
    }
    
    // Mark: Helpers

    private func canRetry() -> Bool {
        return retries < maxAttampts
    }
    
    private func retried() {
        retries += 1
    }
}

