//
//  DictionaryExtension.swift
//  TDDChatProject
//
//  Created by Mendy Edri on 25/12/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import Foundation

public extension Dictionary where Key == String {
    func toData() -> Data {
        return try! JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
    }
}
