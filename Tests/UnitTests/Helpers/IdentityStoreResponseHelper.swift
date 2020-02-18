//
//  IdentityStoreResponseHelper.swift
//  ChatProjectTests
//
//  Created by Mendy Edri on 25/11/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import Foundation

internal struct IdentityStoreResponseHelper {
        
    static func makeJsonItem(_ id: String) -> Data {
        return JSONMockData.identityStoreRemoteApiData(id: id)
    }
    
    static func makeAuthFailedJSON() -> [String: Any] {
        return [
            "responseMeta": [
                "trxId" : "c04a7821-4afd-4230-a4b0-792ed53463d7",
                "reqId": "c04a7821-4afd-4230-a4b0-792ed53463d7",
                "message": "Authentication failed"
            ]
        ]
    }
    
    static func makeAlreadyRegisterJSON(_ id: String) -> [String: Any] {
        return [
            "responseHeader": [
                "isRegister": true,
                "statusMessage": "Identity already exists",
                "record": [
                    "_id": "5dd644ee76a2e50c285c7540",
                    "type": "SMOOCH",
                    "travelerGUID": "A:40775EE7xx",
                    "externalID": id
                ]
            ],
            "responseMeta": [
                "trxId": "27bd641b-fd7f-4c79-a4f1-c90ddac77b7d",
                "reqId": "27bd641b-fd7f-4c79-a4f1-c90ddac77b7d",
                "status": "success"
            ]
        ]
    }
}
