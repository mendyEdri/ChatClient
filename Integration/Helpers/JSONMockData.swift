//
//  JSONMockData.swift
//  Integration
//
//  Created by Mendy Edri on 15/01/2020.
//  Copyright © 2020 CWT. All rights reserved.
//

import Foundation

enum JSONMockData {
    
    static let headerAndMeta = BuilderHelper().buildSuccessHeaderAndMeta()
    
    private static let validChatVendorAppId = ChatVendorAppId(responseHeader: headerAndMeta.0, meta: headerAndMeta.1, appId: "1234554aa")
    
    static func appIdRemoteApiData(from item: ChatVendorAppId = validChatVendorAppId) -> Data {
        return try! JSONEncoder().encode(item)
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
    
    static func vendorTokenRemoteApiData(from item: ChatVendorToken = validChatVendorToken) -> Data {
        return try! JSONEncoder().encode(item)
    }
}

extension JSONMockData {
        
    private static let op = IdentityOps(type: "SMOOCH", travelerGUID: "A:40775EE7xx", externalID: "SMOOCH138", id: "5e3c422f29777d7d947daff6")
    private  static let resw = ResultWrapper(result: IdentityResult(ok: 1, n: 1, opTime: "6790375112093728769"), ops: [JSONMockData.op], insertedCount: 1, insertedIds: IdentityInserted(key: "5e3c422f29777d7d947daff6"))
    
    private static let header = IdentityStoreHeader(statusMessage: "Identity created successfully", record: op, res: resw)
    private static let identityStoreModel = IdentityStoreModel(responseHeader: header, responseMeta: JSONMockData.headerAndMeta.meta)
    
    static func identityStoreRemoteApiData(from item: IdentityStoreModel = identityStoreModel) -> Data {
        return try! JSONEncoder().encode(item)
    }
}
