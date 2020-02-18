//
//  Clients+Helper.swift
//  Integration
//
//  Created by Mendy Edri on 06/02/2020.
//  Copyright © 2020 CWT. All rights reserved.
//

import Foundation
import lit_networking

class Clients {
    let chatClient = ChatClientSpy()
    let httpClient = HTTPClientMock()
    
    let tokenAdapter = AccessTokenMockAdapter()
    
    let storage = UserDefaultStorageMock()
    let jwt = Jwt()
    
    let mockConversation = ChatConversationMock()
    
    func makeManager() -> ClientMediator {
        let strategy = TokenBasedClientStrategy(client: chatClient, storage: storage, jwt: jwt)
        let loaders = clientLoaders()
        
        let managerClients = ClientMediatorClients(
            chatClient: chatClient,
            httpClient: httpClient,
            tokenAdapter: tokenAdapter,
            jwtClient: jwt,
            storage: storage,
            strategy: strategy,
            appIdLoader: loaders.appId,
            vendorTokenLoader: loaders.tokenLoader,
            identityStoreController: loaders.identityStoreController)
        
        return ClientMediator(clients: managerClients)
    }
    
    private func clientLoaders() -> (appId: RemoteAppIdLoader, tokenLoader: RemoteClientTokenLoader, identityStoreController: IdentityStoreController) {
        let appIdLoader = RemoteAppIdLoader(url: URLS.env.smoochVendorAppId, client: httpClient)
        let userTokenLoader = RemoteClientTokenLoader(url: URLS.env.smoochVendorToken, client: httpClient)
        let identityStoreController = IdentityStoreController(url: URLS.env.identityStore, httpClient: httpClient, identityInfo: IdentityStoreDataHelper.defaultIndetityInfo(), storage: storage)
        
        return (appIdLoader, userTokenLoader, identityStoreController)
    }
    
    lazy var facade: ChatFacade = ChatFacade(mediator: self.makeManager(), conversation: self.mockConversation)
    
    func config(email: String, tokenAdapter: AccessTokenAdapter = AccessTokenMockAdapter()) {
        facade.settings(email: email, tokenAdapter: tokenAdapter)
    }
}
