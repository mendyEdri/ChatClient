//
//  SmoochChatClient.swift
//  ChatHTTPLoader
//
//  Created by Mendy Edri on 06/11/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import Foundation

import Smooch

public class SmoochChatClient: ChatClient {
        
    public func startSDK(_ appId: String?, completion: @escaping (StartResult) -> Void) {
        guard let appId = appId else { return completion(.failure(.initFailed)) }
        let skSettings = SKTSettings(appId: appId)
        Smooch.initWith(skSettings) { (error, info) in
            completion(.success(appId))
        }
    }
    
    public func initialized() -> Bool {
        return Smooch.conversation() != nil
    }
    
    public func login(userId: String, token: String, completion: @escaping (LoginResult) -> Void) {
        Smooch.login(userId, jwt: token) { (error, info) in
            if error != nil {
                return completion(.failure(.invalidToken))
            }
            completion(.success(token))
        }
    }
    
    public func loggedIn() -> Bool {
        return SKTUser.current()?.userId != nil
    }
    
    public func logout(completion: @escaping (LoginResult) -> Void) {
        #warning("Check it out, what should we should do")
        completion(.success(""))
    }
}
