//
//  SmoochChatClient.swift
//  ChatHTTPLoader
//
//  Created by Mendy Edri on 06/11/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import Foundation
import Smooch

class AuthenticationDelegate: NSObject, SKTAuthenticationDelegate {
    
    func onInvalidToken(_ error: Error, handler completionHandler: @escaping SKTAuthenticationCompletionBlock) {
        DispatchQueue.main.async {
            ChatDefaultComposition.manager.renewUserToken { result in
                let newToken = try? result.get()
                completionHandler(newToken ?? "")
            }
        }
    }
}

public class SmoochChatClient: ChatClient {
        
    private var authenticationDelegate = AuthenticationDelegate()
    
    public func startSDK(_ appId: String?, completion: @escaping (StartResult) -> Void) {
        guard let appId = appId else { return completion(.failure(.initFailed)) }
        
        Smooch.initWith(chatSettings(with: appId)) { (error, info) in
            guard error == nil else {
                Smooch.destroy()
                
                return completion(.failure(.initFailed))
            }
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
        Smooch.logout { error, info in
            if error != nil {
                return completion(.failure(.logoutFails))
            }
            return completion(.success(""))
        }
    }
    
    // MARK: Helpers
    
    private func chatSettings(with appId: String) -> SKTSettings {
        let settings = SKTSettings(appId: appId)
        settings.authenticationDelegate = authenticationDelegate
        return settings
    }
}
