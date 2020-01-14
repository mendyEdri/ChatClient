//
//  AccessTokenTempAdapter.swift
//  TDDChatProject
//
//  Created by Mendy Edri on 14/01/2020.
//  Copyright © 2020 CWT. All rights reserved.
//

import Foundation
import lit_networking

class AccessTokenTempAdapter: AccessTokenAdapter {
    func requestAccessToken(_ completion: (Result<String, Error>) -> Void) {
        completion(.success(""))
    }
}
