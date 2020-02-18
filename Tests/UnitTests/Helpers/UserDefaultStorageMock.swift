//
//  UserDefaultStorageMock.swift
//  ChatProjectTests
//
//  Created by Mendy Edri on 02/12/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import Foundation
import ChatProject

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
