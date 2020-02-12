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
        
        let strategy = TokenBasedClientStrategy(client: smoochClient, storage: storage, jwt: jwt)
        
        let managerClients = ClientMediatorClients(
            chatClient: smoochClient,
            httpClient: httpClient,
            tokenAdapter: tokenAdapter,
            jwtClient: jwt,
            storage: storage,
            strategy: strategy)
    
        return ClientMediator(clients: managerClients)
    }
    
    
    static let facade: ChatFacade = ChatFacade(mediator: ChatDefaultComposition.manager, conversation: SmoochConversation())
    
    static func config(email: String, tokenAdapter: AccessTokenAdapter) {
        ChatDefaultComposition.facade.settings(email: email, tokenAdapter: tokenAdapter)
    }
    
    private init() {} 
}
