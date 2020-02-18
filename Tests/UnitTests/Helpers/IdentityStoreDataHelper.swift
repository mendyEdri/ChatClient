//
//  IdentityStoreDataHelper.swift
//  ChatProject
//
//  Created by Mendy Edri on 16/02/2020.
//  Copyright © 2020 CWT. All rights reserved.
//

import Foundation

struct IdentityStoreDataHelper {

    static func defaultIndetityInfo() -> IdentityInfo {
        let metadata = IdentityMetadata(type: "SMOOCH", travelerGUID: "A:40775EE7xx", externalID: "SMOOCH138x-1")
        let info = IdentityInfo(topId: "A:79A8F", subId: "A:79A9", userId: "253636", metadata: metadata)
        return info
    }
    
}
