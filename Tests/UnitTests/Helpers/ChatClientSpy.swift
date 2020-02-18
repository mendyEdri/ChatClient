//
//  ChatClientSpy.swift
//  ChatProjectTests
//
//  Created by Mendy Edri on 05/12/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import Foundation
import ChatProject

final class ChatClientSpy: ChatClient {    
    
    typealias Error = ClientMediator.Error
    typealias Result = ClientMediator.Result
    
    private var startCompletions = [(StartResult) -> Void]()
    private var loginCompletions = [(LoginResult) -> Void]()
    private var logoutCompletions = [(LoginResult) -> Void]()
    internal var isInitialize = false 
    private var isLoggedIn = false
    
    func startSDK(_ appId: String?, completion: @escaping (StartResult) -> Void) {
        startCompletions.append(completion)
    }
    
    func login(userId: String, token: String, completion: @escaping (LoginResult) -> Void) {
        loginCompletions.append(completion)
    }
    
    func logout(completion: @escaping (LoginResult) -> Void) {
        logoutCompletions.append(completion)
    }
    
    func loggedIn() -> Bool {
        return isLoggedIn
    }
    
    func initialized() -> Bool {
        return isInitialize
    }
    
    // MARK: - Mock Executions, Don't get exited
    
    func completeStartSDKSuccessfuly(_ index: Int = 0) {
        isInitialize = true
        startCompletions[index](.success(anyAppId))
    }
    
    func completeStartSDKWithError(_ index: Int = 0) {
        isInitialize = false
        startCompletions[index](.failure(Error.initFailed))
    }
    
    func completeLoginWithSuccess(_ index: Int = 0) {
        isLoggedIn = true
        loginCompletions[index](.success(anyUserToken))
    }
    
    func completeLoginWithErrorInvalidToken(_ index: Int = 0) {
        isLoggedIn = false
        loginCompletions[index](.failure(Error.invalidToken))
    }
    
    func completeLoginWithErrorSDKNotInitialized(_ index: Int = 0) {
        loginCompletions[index](.failure(Error.sdkNotInitialized))
    }
}

extension ChatClientSpy {
    var anyAppId: String {
        return "1209381xxJJ"
    }
    
    var anyUserToken: String {
        return "altj"
    }
}
