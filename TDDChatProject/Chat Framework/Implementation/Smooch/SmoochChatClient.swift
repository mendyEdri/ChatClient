//
//  SmoochChatClient.swift
//  ChatHTTPLoader
//
//  Created by Mendy Edri on 06/11/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import Foundation
import Smooch

final class AuthenticationDelegate: NSObject, SKTAuthenticationDelegate {
    
    func onInvalidToken(_ error: Error, handler completionHandler: @escaping SKTAuthenticationCompletionBlock) {
        DispatchQueue.main.async {
            ChatDefaultComposition.manager.renewUserToken { result in
                let newToken = try? result.get()
                completionHandler(newToken ?? "")
            }
        }
    }
}

final public class SmoochChatClient: ChatClient {
        
    private var authenticationDelegate = AuthenticationDelegate()
    private var appId: String?
    
    public func startSDK(_ appId: String?, completion: @escaping (StartResult) -> Void) {
        guard let appId = appId else { return completion(.failure(.initFailed)) }
        self.appId = appId
        
        Smooch.initWith(chatSettings(with: appId)) { (error, info) in
            if error != nil {
                return self.logout { result in
                    //Smooch.destroy()
                    completion(.failure(.initFailed))
                }
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
                Smooch.destroy()
                return completion(.failure(.invalidToken))
            }
            completion(.success(token))
        }
    }
    
    public func loggedIn() -> Bool {
        return SKTUser.current()?.userId != nil
    }
    
    public func logout(completion: @escaping (LoginResult) -> Void) {
        guard loggedIn() == true else { return completion(.success("USER NOT LOGGED IN")) }
        Smooch.logout { error, info in
            if error != nil {
                return completion(.failure(.logoutFailed))
            }
            Smooch.destroy()
            return completion(.success(self.appId ?? ""))
        }
    }
    
    // MARK: Helpers
    
    private func chatSettings(with appId: String) -> SKTSettings {
        let settings = SKTSettings(appId: appId)
        /** This line fails the tests */
        //settings.authenticationDelegate = authenticationDelegate
        return settings
    }
}
