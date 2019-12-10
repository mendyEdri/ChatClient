//
//  ChatClientSpy.swift
//  TDDChatProjectTests
//
//  Created by Mendy Edri on 05/12/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import Foundation
@testable import TDDChatProject

/** Enum type returns success or failure with an associated value */
public struct ChatSettings {
    var appId: String
    var token: String
    var userId: String?
}

class ChatClientSpy: ChatClient {    
    
    typealias Error = ClientManager.Error
    typealias Result = ClientManager.Result
    
    var settings: ChatSettings
    
    private var startCompletions = [(StartResult) -> Void]()
    private var loginCompletions = [(LoginResult) -> Void]()
    private var logoutCompletions = [(LoginResult) -> Void]()
    internal var isInitialize = false 
    private var isLoggedIn = false
    
    
    internal init(settings: ChatSettings) {
        self.settings = settings
    }
    
    func startSDK(_ appId: String, completion: @escaping (StartResult) -> Void) {
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
        startCompletions[index](.success(settings.appId))
    }
    
    func completeStartSDKWithError(_ index: Int = 0) {
        isInitialize = false
        startCompletions[index](.failure(Error.initFailed))
    }
    
    func completeLoginWithSuccess(_ index: Int = 0) {
        isLoggedIn = true
        loginCompletions[index](.success(settings.userId!))
    }
    
    func completeLoginWithErrorInvalidUserID(_ index: Int = 0) {
        isLoggedIn = false
        loginCompletions[index](.failure(Error.invalidUserID))
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
    var anyUserId: String {
        return "altj"
    }
}
