//
//  RetryCommand.swift
//  TDDChatProject
//
//  Created by Mendy Edri on 22/12/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import Foundation

protocol Retry {
    
}

public class RetryExecutor {
    private var retries = 0
    var maxAttampts: Int
    
    public init(attempts: Int) {
        self.maxAttampts = attempts
    }
    
    public func canRetry() -> Bool {
        return retries < maxAttampts
    }
    
    public func retried() {
        retries += 1
    }
    
    public func reset() {
        retries = 0
    }
}

