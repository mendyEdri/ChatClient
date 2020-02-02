//
//  AccessTokenPingAdapter.swift
//  TDDChatProject
//
//  Created by Mendy Edri on 29/01/2020.
//  Copyright © 2020 CWT. All rights reserved.
//

import Foundation
import lit_networking

class AccessTokenPingAdapter: AccessTokenAdapter {
    
    func requestAccessToken(_ completion: @escaping (Result<String, Error>) -> Void) {
        #warning("Replace it with a real implementation")
        
        fatalError("This should not be called, until real implementation")
        completion(.success(""))
    }
}
