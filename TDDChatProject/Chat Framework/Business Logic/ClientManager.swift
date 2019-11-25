//
//  ChatClientManager.swift
//  CWTTests
//
//  Created by Mendy Edri on 07/11/2019.
//

import Foundation

/** Holds application specific business logic, interact with ChatClient and run the right client request, according to it state. */

public class ClientManager {
    
    private let client: ChatClient
    
    /** Prepare function Result-type error */
    public enum Error: Swift.Error {
        case initFailed
        case invalidUserID
        case invalidToken
        case sdkNotInitialized
        case logoutFails
    }
    
    public typealias Result = Swift.Result<String, ClientManager.Error>
    
    public init(chat: ChatClient) {
        self.client = chat
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
        client.startSDK(appId) { [weak self] result in
            guard self != nil else { return }
            completion(result)
        }
    }
    
    internal func login(userId: String, token: String, completion: @escaping (Result) -> Void) {
        guard client.canLogin() == true else {
            completion(.failure(.sdkNotInitialized))
            return
        }
        client.login(userId: userId, token: token) { result in
            completion(result)
        }
    }
}


