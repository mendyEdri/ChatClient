//
//  IdentityStoreInfo.swift
//  ChatProject
//
//  Created by Mendy Edri on 16/02/2020.
//  Copyright © 2020 CWT. All rights reserved.
//

import Foundation

public struct IdentityMetadata: Codable {
    let type: String
    let travelerGUID: String
    let externalID: String
}

public struct IdentityInfo: Codable {
    let topId: String
    let subId: String
    let userId: String
    let clientType: String = "iOS"
    let metadata: IdentityMetadata
}
