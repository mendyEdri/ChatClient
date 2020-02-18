//
//  IdentityStoreModel.swift
//  ChatProject
//
//  Created by Mendy Edri on 21/11/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import Foundation
/** Response model, subtype of IdentityStoreModel.
    Holds data about servers' operation/insetion time and if it succeeded */
public struct IdentityResult: Codable, Equatable {
    var ok: Int
    var n: Int
    var opTime: String
}

/** Response model, subtype of IdentityStoreModel.
    Holds information about servers' type of operation and what information inserted by the API call */
public struct IdentityOps: Codable, Equatable {
    var type: String
    var travelerGUID: String
    var externalID: String
    var id: String
    
    enum CodingKeys: String, CodingKey {
        case type
        case travelerGUID
        case externalID
        case id = "_id"
    }
}

/** Response model, subtype of IdentityStoreModel.
    Holds count of how many insertions the the server made by this API call. */
public struct IdentityInserted: Codable, Equatable {
    var key: String
    
    enum CodingKeys: String, CodingKey {
        case key = "0"
    }
}

/** Response model, subtype of IdentityStoreModel.
    Structure holds IdentityResult, IdentityOps, IdentityInserted and IdentityInserted */
public struct ResultWrapper: Codable, Equatable {
    var result: IdentityResult
    var ops: [IdentityOps]
    var insertedCount: Int
    var insertedIds: IdentityInserted
}

/** Response model, holds body response. */
public struct IdentityStoreHeader: Codable, Equatable {
    var statusMessage: String
    var isRegister: Bool?
    var record: IdentityOps?
    var res: ResultWrapper?
}

/** Response model - Top level */
public struct IdentityStoreModel: Equatable, Codable {
    var responseHeader: IdentityStoreHeader
    var responseMeta: ResponseMetadata
}
