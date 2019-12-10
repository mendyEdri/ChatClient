//
//  ClientProcessStrategy.swift
//  TDDChatProject
//
//  Created by Mendy Edri on 08/12/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import Foundation

/** Strategy Protocol, aggregate data from ChatClient and actions parameters (`appIdAvailable()`, `userTokenAvailable()`, `userTokenIsValid()`) to define the next process step. `userTokenAvailable` and `userTokenIsValid` to let separate the non-existing-token state with the existing-expired-token state.
    This protocol can be implemented differently for different type of SDK's or need.
 */

protocol ClientProcessStrategy {
    var appIdAvailable: () -> Bool { get set }
    var userTokenAvailable: () -> Bool { get set }
    var userTokenIsValid: () -> Bool { get set }
    var client: ChatClient { get }
}
