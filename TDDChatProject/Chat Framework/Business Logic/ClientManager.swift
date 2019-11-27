//
//  ChatClientManager.swift
//  CWTTests
//
//  Created by Mendy Edri on 07/11/2019.
//

import Foundation

/** Holds application specific business logic, interact with ChatClient and run the right client request, according to it state. */

public class ClientManager {
    
    private let chatClient: ChatClient
    private let httpClient: ChatHTTPClient
    
    /** Prepare function Result-type error */
    public enum Error: Swift.Error {
        case initFailed
        case invalidUserID
        case invalidToken
        case sdkNotInitialized
        case logoutFails
    }
    
    public typealias Result = Swift.Result<String, ClientManager.Error>
    
    public init(chat: ChatClient, httpClient: ChatHTTPClient) {
        self.chatClient = chat
        self.httpClient = httpClient
    }
    
    /** Instantiate Chat SDK and Login */
    public func prepare(with settings: ChatSettings, _ completion: @escaping (Result) -> Void) {
        
        start(settings.appId) { [weak self] startResult in
            guard let self = self else { return }
            
            guard case .success(_) = startResult else {
                /** Start SDK failed so we return the startResult which is an Error now */
                completion(startResult)
                return
            }
            
            self.login(userId: settings.userId, token: settings.token) { [weak self] result in
                guard self != nil else { return }
                completion(result)
            }
        }
    }
    
    internal func start(_ appId: String, completion: @escaping ((Result) -> Void)) {
        chatClient.startSDK(appId) { [weak self] result in
            guard self != nil else { return }
            completion(result)
        }
    }
    
    internal func login(userId: String, token: String, completion: @escaping (Result) -> Void) {
        guard chatClient.canLogin() == true else {
            completion(.failure(.sdkNotInitialized))
            return
        }
        chatClient.login(userId: userId, token: token) { result in
            completion(result)
        }
    }
}

extension ClientManager {
    
    // Given the appId isn't saved locally
    // When the prepare() get called
    // Then the app will request the STS-metadata API
    
    // Given the appId is saved locally
    // When the prepare() get called
    // Then the app will check if user token is saved locally
    
    // Given the user token isn't saved locally
    // When the prepare() get called
    // Then the app will call STS API
    
    // Given the user token is saved locally
    // When the prepare() get called
    // Then the app will call initialize on the ChatClient
    
    // Given the app called STS-metadata request completed
    // When the request completed successfuly
    // Then the app will save the appId locally
    
    // Given the app called STS-metadata request completed
    // When the request completed with error
    // Then the app will retry for one more time
    
    internal func retreiveRemoteAppId() {
        let appIdLoader = RemoteAppIdLoader(url: URL(string: "")!, client: httpClient)
        appIdLoader.load { result in
            
        }
    }
}

