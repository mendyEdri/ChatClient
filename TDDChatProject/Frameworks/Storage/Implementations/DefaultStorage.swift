//
//  DefaultStorage.swift
//  TDDChatProject
//
//  Created by Mendy Edri on 25/11/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import Foundation

public struct UserDefaultsStorage: Storage {
    
    private var defaults = UserDefaults.standard
    
    public init() {}
    
    public func save(value: Any?, for key: String) {
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }
    
    public func delete(key: String) {
        defaults.removeObject(forKey: key)
        defaults.synchronize()
    }
    
    public func value(for key: String) -> Any? {
        return defaults.value(forKey: key)
    }
    
    public func hasValue(for key: String) -> Bool {
        return defaults.value(forKey: key) != nil
    }
    
    public func keyValues() -> [String: Any] {
        return defaults.dictionaryRepresentation()
    }
}
