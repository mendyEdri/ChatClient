//
//  SmoochChatClient.swift
//  ChatHTTPLoader
//
//  Created by Mendy Edri on 06/11/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import Foundation

/*
import Smooch

class ChatableAuthDelegate: NSObject, SKTAuthenticationDelegate {
    func onInvalidToken(_ error: Error, handler completionHandler: @escaping SKTAuthenticationCompletionBlock) {
        print("re authenticate")
    }
}

public struct SmoochChatClient: ChatClient {
    
    public var appId: String
    
    // SDK Specific implementation - those it's not in Chatable Protocol
    private var authDelegate = ChatableAuthDelegate()
    
    public enum Error: Swift.Error {
        case connectivity
        case authFailed
    }
    
    public init(appId: String) {
        self.appId = appId
    }
    
    public func startSDK(completion: @escaping (StartResult) -> Void) {
        guard isInitialize() == true else {
            completion(.success(appId))
            return
        }
        
        let settings = SKTSettings(appId: appId)
        settings.authenticationDelegate = authDelegate
        
        Smooch.initWith(settings) { (error, userInfo) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(self.appId))
            }
        }
    }
    
    // TODO: make it internal/private
    public func isInitialize() -> Bool {
        return Smooch.conversation() != nil
    }
    
    public func login(userId: String, token: String, completion: @escaping (LoginResult) -> Void) {
        Smooch.login(userId, jwt: token) { (error, userInfo) in
            completion(.success(""))
        }
    }
    
    public func logout(completion: @escaping (LoginResult) -> Void) {
        Smooch.logout { (error, userInfo) in
            completion(.success(""))
        }
    }
    
    // MARK:
}
*/
