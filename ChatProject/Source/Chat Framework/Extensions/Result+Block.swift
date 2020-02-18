//
//  ResultExtension.swift
//  ChatProject
//
//  Created by Mendy Edri on 15/12/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import Foundation

/** Add code block for success of failure under any result type */

extension Result {
    public func success(_ action: () -> Void) {
        if case .success = self {
            action()
        }
    }
    
    public func success(_ action: (Success) -> Void) {
        if case let .success(success) = self {
            action(success)
        }
    }
    
    public func failure(_ action: () -> Void) {
        if case .failure = self {
            action()
        }
    }
    
    public func failure(_ action: (Error) -> Void) {
        if case let .failure(error) = self {
            action(error)
        }
    }
}

extension Result {
    public var succeeded: Bool {
        if case .success = self {
            return true
        }
        return false
    }
    
    public var failed: Bool {
        if case .success = self {
            return true
        }
        return false
    }
}
