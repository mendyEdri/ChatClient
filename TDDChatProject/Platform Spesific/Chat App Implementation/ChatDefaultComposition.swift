//
//  ChatDefaultComposition.swift
//  TDDChatProject
//
//  Created by Mendy Edri on 10/12/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import Foundation
import lit_networking

struct ChatDefaultComposition {
    
    static var manager = ChatDefaultComposition.makeManager()
    
    private static func makeManager() -> ClientMediator {
        let smoochClient = SmoochChatClient()
        let httpClient = URLSessionHTTPClient()
        let storage = UserDefaultsStorage()
        let jwt = Jwt()
        let tokenAdapter = AccessTokenPingAdapter()
        let loaders = ChatDefaultComposition.loaders(httpClient: httpClient, storage: storage)
        
        let strategy = TokenBasedClientStrategy(client: smoochClient, storage: storage, jwt: jwt)
        
        let managerClients = ClientMediatorClients(
            chatClient: smoochClient,
            httpClient: httpClient,
            tokenAdapter: tokenAdapter,
            jwtClient: jwt,
            storage: storage,
            strategy: strategy,
            appIdLoader: loaders.appIdLoader,
            vendorTokenLoader: loaders.tokenLoader,
            identityStoreController: loaders.identityController)
        
        return ClientMediator(clients: managerClients)
    }
    
    private static func loaders(httpClient: HTTPClient, storage: Storage) -> (appIdLoader: RemoteAppIdLoader, tokenLoader: RemoteClientTokenLoader, identityController: IdentityStoreController) {
        let appIdLoader = RemoteAppIdLoader(url: URLS.env.smoochVendorAppId, client: httpClient)
        let userTokenLoader = RemoteClientTokenLoader(url: URLS.env.smoochVendorToken, client: httpClient)
        
        let identityStoreController = IdentityStoreController(url: URLS.env.identityStore, httpClient: httpClient, identityInfo: buildIdentityInfo(), storage: storage)
        
        return (appIdLoader, userTokenLoader, identityStoreController)
    }
    
    
    private static func buildIdentityInfo() -> IdentityInfo {
        let metadata = IdentityMetadata(type: "SMOOCH", travelerGUID: "A:40775EE7xx", externalID: "SMOOCH138x")
        let info = IdentityInfo(topId: "A:79A8F", subId: "A:79A9", userId: "253636", metadata: metadata)
        return info
    }
    
    static let facade: ChatFacade = ChatFacade(mediator: ChatDefaultComposition.manager, conversation: SmoochConversation())
    
    static func config(email: String, tokenAdapter: AccessTokenAdapter) {
        ChatDefaultComposition.facade.settings(email: email, tokenAdapter: tokenAdapter)
    }
    
    private init() {} 
}
