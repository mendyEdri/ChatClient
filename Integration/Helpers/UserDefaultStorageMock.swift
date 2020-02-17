//
//  UserDefaultStorageMock.swift
//  Integration
//
//  Created by Mendy Edri on 15/01/2020.
//  Copyright © 2020 CWT. All rights reserved.
//

import Foundation
import TDDChatProject

final class UserDefaultStorageMock: Storage {
    private var storage = [String: Any]()
    
    func save(value: Any?, for key: String) {
        storage[key] = value
    }
    
    func delete(key: String) {
        storage[key] = nil
    }
    
    func value(for key: String) -> Any? {
        return storage[key]
    }
    
    func hasValue(for key: String) -> Bool {
        return (value(for: key) != nil)
    }
    
    func keyValues() -> [String: Any] {
        return storage
    }
}
