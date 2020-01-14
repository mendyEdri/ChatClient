//
//  ResultExtension.swift
//  TDDChatProject
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
    
    public func failure(_ action: () -> Void) {
        if case .failure = self {
            action()
        }
    }
}
