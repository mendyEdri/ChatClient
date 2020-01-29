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

extension JSONMockData {
    
    private static let tokenType = "Bearer"
    private static let anyToken = "0222.wearethepeople"
    private static let fourHoursExpiration: TimeInterval = 14400
    private static let anyCWTToken = "10202020.fuc&plasticsavetheworld"
    // Experation Date in 2032
    private static let validVendorToken =  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6ImFwcF81YzA2MWUyZmJlOWNjMDAwMjIwMDMwOWMifQ.eyJzY29wZSI6ImFwcFVzZXIiLCJpYXQiOjE1Nzk2MjI5ODYsInVzZXJJZCI6Ijc3N2FlMDhiLTZhNmItNDJlOS05MDY4LTMxNGRlMDRiYzk4MiIsImV4cCI6MTk3OTYzNzM4Nn0.XvBz-bs3v0A9xyVAlKmBUPZktbuZxjWbcO4OBt5rbeY"
    
    static let validChatVendorToken = ChatVendorToken(header: JSONMockData.headerAndMeta.header, tokenType: JSONMockData.tokenType, accessToken: JSONMockData.validVendorToken, expiration: JSONMockData.fourHoursExpiration, cwtToken: JSONMockData.anyCWTToken, metadata: JSONMockData.headerAndMeta.meta)
    
    static func vendorTokenRemoteApiData(from item: ChatVendorToken = validChatVendorToken) -> [String: AnyHashable] {
        return ["responseHeader": ["statusMessage": item.header.statusMessage],
                "token_type": item.tokenType,
                "access_token": item.accessToken,
                "expires_in": item.expiration,
                "cwtToken": item.cwtToken,
                "responseMeta": [
                    "trxId": item.metadata.trxId,
                    "reqId": item.metadata.reqId,
                    "status": item.metadata.status ]
            ] as [String: AnyHashable]
    }
}
