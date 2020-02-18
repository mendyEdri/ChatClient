//
//  Commands.swift
//  TDDChatProject
//
//  Created by Mendy Edri on 15/12/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import Foundation
import lit_networking

/** Commands needs to run the sdk initialization process, conforms to AnyObject to have the Commands instance weak - to prevent retains cycle  */
protocol Commands: AnyObject {
    typealias CommandsCompletion = (Swift.Result<String, ClientMediator.Error>) -> Void
    
    func getRemoteAppId(loader: RemoteAppIdLoader, completion: @escaping CommandsCompletion)
    func getRemoteToken(tokenAdapter: AccessTokenAdapter, loader: RemoteClientTokenLoader, completion: @escaping CommandsCompletion)
    func startSDK(for sdk: (client: ChatClient, appId: String?), completion: @escaping CommandsCompletion)
    func loginSDK(for sdk: (client: ChatClient, token: String?, userId: String?), completion: @escaping CommandsCompletion)
}

extension Commands {
    
    internal func getRemoteAppId(loader: RemoteAppIdLoader, completion: @escaping CommandsCompletion) {
        loader.load { [weak self] in
            guard self != nil else { return }
            completion($0.map { $0.appId }.mapError { _ in .failedFetchAppId })
        }
    }
    
    internal func getRemoteToken(tokenAdapter: AccessTokenAdapter, loader: RemoteClientTokenLoader, completion: @escaping CommandsCompletion) {
        loader.load(with: tokenAdapter) { [weak self] in
            guard self != nil else { return }
            completion($0.map { $0.accessToken }.mapError { _ in .failedFetchToken })
        }
        
    }
    
    internal func startSDK(for sdk: (client: ChatClient, appId: String?), completion: @escaping CommandsCompletion) {
        let client = sdk.client
        client.startSDK(sdk.appId) { [weak self] in
            guard self != nil else { return }
            completion($0.mapError { _ in .initFailed })
        }
    }
    
    #warning("Method is too long and doing too many things")
    internal func loginSDK(for sdk: (client: ChatClient, token: String?, userId: String?), completion: @escaping CommandsCompletion) {
        
        guard let userId = sdk.userId, let token = sdk.token else {
            return completion(.failure(.invalidToken))
        }
        
        let client = sdk.client
        guard client.initialized() == true else {
            completion(.failure(.sdkNotInitialized))
            // to indicate failing if login called before initialize SDK
            return
        }
        
        client.login(userId: userId, token: token) { [weak self] result in
            guard self != nil else { return }
            completion(result.mapError { _ in return .loginFailed })
        }
    }
}
