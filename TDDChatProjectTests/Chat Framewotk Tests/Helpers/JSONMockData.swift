//
//  JSONMockData.swift
//  TDDChatProjectTests
//
//  Created by Mendy Edri on 12/12/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import Foundation
@testable import TDDChatProject

enum JSONMockData {
    
    static let headerAndMeta = BuilderHelper().buildSuccessHeaderAndMeta()
    
    private static let validChatVendorAppId = ChatVendorAppId(responseHeader: headerAndMeta.0, meta: headerAndMeta.1, appId: "1234554aa")
    
    
    static func appIdRemoteApiData(from item: ChatVendorAppId = validChatVendorAppId) -> [String: AnyHashable] {
        return ["responseHeader": [
                             "statusMessage": item.responseHeader.statusMessage
                        ],
                         "appId": item.appId,
                         "responseMeta": [
                             "trxId": item.meta.trxId,
                             "reqId": item.meta.reqId,
                             "status": item.meta.status
                     ]] as [String : AnyHashable]
    }
}
