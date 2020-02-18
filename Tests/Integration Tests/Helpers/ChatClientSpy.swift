//
//  ChatClientMock.swift
//  Integration
//
//  Created by Mendy Edri on 15/01/2020.
//  Copyright © 2020 CWT. All rights reserved.
//

import Foundation
import ChatProject

final class ChatClientSpy: ChatClient {
    
    var startCompletions = [(StartResult) -> Void]()
    var loginCompletions = [(LoginResult) -> Void]()
    var logoutCompletions = [(LoginResult) -> Void]()
    
    private var isInitialized = false
    private var isLoggedIn = false
    
    func startSDK(_ appId: String?, completion: @escaping (StartResult) -> Void) {
        startCompletions.append(completion)
    }
    
    func initialized() -> Bool {
        return isInitialized
    }
    
    func loggedIn() -> Bool {
        return isLoggedIn
    }
    
    func login(userId: String, token: String, completion: @escaping (LoginResult) -> Void) {
        loginCompletions.append(completion)
    }
    
    func logout(completion: @escaping (LoginResult) -> Void) {
        logoutCompletions.append(completion)
    }

    func completeStartSDKSuccessfuly(at index: Int = 0) {
        isInitialized = true
        startCompletions[index](.success(anyAppId))
    }
    
    func completeStartSDKWithError(at index: Int = 0) {
        isInitialized = false
        startCompletions[index](.failure(.initFailed))
    }
    
    func completeLoginSuccessfuly(at index: Int = 0) {
        isLoggedIn = true
        loginCompletions[index](.success(anyUserToken))
    }
    
    func completeLoginWithError(at index: Int = 0) {
        loginCompletions[index](.failure(.loginFailed))
    }
    
    func completeLogoutSuccessfuly(at index: Int = 0) {
        isLoggedIn = false
        logoutCompletions[index](.success(anyUserToken))
    }
    
    func completeLogoutWithError(at index: Int = 0) {
        logoutCompletions[index](.failure(.logoutFailed))
    }
}

private extension ChatClientSpy {
    var anyAppId: String {
        return "1239484"
    }
    
    var anyUserToken: String {
        return "ABCD.11#"
    }
}

