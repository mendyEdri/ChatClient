//
//  ClientProcessStrategy.swift
//  ChatProject
//
//  Created by Mendy Edri on 08/12/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import Foundation

/** Strategy design for decision making for next ClientMediator step in the initialization process. */
final internal class TokenBasedClientStrategy: TokenBasedProcessStrategy {
    
    internal var storage: Storage
    
    internal var jwt: Jwtable
    
    internal var client: ChatClient
    
    // Helpers Properties
    
    internal var appIdAvailable: Bool {
        if let appId = self.storage.value(for: self.client.appIdKey) as? String, !appId.isEmpty {
            return true
        }
        return false
    }
    
    internal var userTokenAvailable: Bool {
        return self.storage.hasValue(for: self.client.userTokenKey)
    }
    
    internal var userTokenIsValid: Bool {
        let valid = try? !self.jwt.isJwtExp()
        return valid ?? false
    }
        
    init(client: ChatClient, storage: Storage, jwt: Jwtable) {
        self.client = client
        self.storage = storage
        self.jwt = jwt
    }
        
    func nextStepExecution() -> ChatManagerNextStepType {
        self.makeJWT()
        
        if appIdAvailable == false {
            return .remoteFetchAppId
        }
        
        if isUserTokenAvailableAndNotExpired() == false {
            return .remoteFetchUserToken
        }
        
        if client.initialized() == false {
            return .SDKInit
        }
        
        if client.loggedIn() == false {
            return .SDKLogin
        }
        
        return .SDKReadyToUse
    }
    
    // MARK: Helpers
    
    private func makeJWT() {
        if let token = storage.value(for: client.userTokenKey) as? String {
            jwt = Jwt(string: token, parser: JwtDefaultParser())
        }
    }
    
    private func isUserTokenAvailableAndNotExpired() -> Bool {
        return userTokenAvailable && userTokenIsValid
    }
}
