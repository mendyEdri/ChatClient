//
//  ClientProcessStrategy.swift
//  TDDChatProject
//
//  Created by Mendy Edri on 08/12/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import Foundation

internal enum ChatManagerNextStepType {
    case remoteFetchAppId
    case remoteFetchUserToken
    case SDKInit
    case SDKLogin
    case SDKReadyToUse
}

/** Strategy Protocol, aggregate data from ChatClient.
   This protocol can be implemented differently for different type of SDK's needs.
*/

protocol BasicProcessStrategy {
    var client: ChatClient { get }
    func nextStepExecution() -> ChatManagerNextStepType
}

/**
 Default implementation of Basic ProcessStrategy.
 aggregates actions parameters (`appIdAvailable()`, `userTokenAvailable()`, `userTokenIsValid()`) to define the next process step. `userTokenAvailable` and `userTokenIsValid` to let separate the non-existing-token state with the existing-expired-token state, that could have a different behaviour in the future, for example, call some re-authentication method instead of getting a new token.
 */
protocol TokenBasedProcessStrategy: BasicProcessStrategy {
    var appIdAvailable: Bool { get }
    var userTokenAvailable: Bool { get }
    var userTokenIsValid: Bool { get }
    var storage: Storage { get }
    var jwt: Jwtable { get }
}
