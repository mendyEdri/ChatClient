//
//  Storage.swift
//  DefaultStorage
//
//  Created by Mendy Edri on 29/10/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import Foundation

public protocol Storage {
    func save(value: Any?, for key: String)
    func delete(key: String)
    func value(for key: String) -> Any?
    func hasValue(for key: String) -> Bool
    func keyValues() -> [String: Any]
}
