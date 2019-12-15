//
//  Requests.swift
//  TDDChatProject
//
//  Created by Mendy Edri on 11/12/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import Foundation

internal enum Requests {
    
    static func start(client: ChatClient, with appId: String?, completion: @escaping ((ClientManager.Result) -> Void)) {
        guard let appId = appId else { return completion(.failure(.initFailed)) }
        client.startSDK(appId) { result in
            completion(result)
        }
    }
    
    static func login(client: ChatClient, with userId: String?, token: String?, completion: @escaping ((ClientManager.Result) -> Void)) {
        
        guard let userId = userId, let token = token else {
            return completion(.failure(.logoutFails))
        }
        
        guard client.initialized() == true else {
            completion(.failure(.sdkNotInitialized))
            // to indicate failing if login called before initialize SDK
            return
        }
        client.login(userId: userId, token: token) { result in
            completion(result)
        }
    }
}

// MARK: - Our Endpoints Calls (AppId + Token)

extension Requests {
    static func loadUserToken(loader: RemoteTokenLoader, completion: @escaping (RemoteTokenLoader.Result) -> Void) {
        loader.load { result in
            completion(result)
        }
    }
}
