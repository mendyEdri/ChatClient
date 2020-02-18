//
//  URLS+IdentityStore.swift
//  ChatProject
//
//  Created by Mendy Edri on 05/02/2020.
//  Copyright © 2020 CWT. All rights reserved.
//

import Foundation

extension URLS {
    /** /identity-store/api/v1/register */
    var identityStore: URL {
        return URL(string: "\(apiBase)/identity-store/api/v1/register")!
    }
}
