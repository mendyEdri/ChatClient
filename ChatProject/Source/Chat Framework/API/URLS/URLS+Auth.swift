//
//  URLS+Auth.swift
//  ChatProject
//
//  Created by Mendy Edri on 05/02/2020.
//  Copyright © 2020 CWT. All rights reserved.
//

import Foundation

extension URLS {
    /** /as/token.oauth2 */
    var authEndpoint: URL {
        return URL(string: "\(accountsBase)/as/token.oauth2")!
    }
}
