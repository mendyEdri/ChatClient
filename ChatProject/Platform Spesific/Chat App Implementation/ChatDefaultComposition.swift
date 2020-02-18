//
//  ChatDefaultComposition.swift
//  ChatProject
//
//  Created by Mendy Edri on 10/12/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import Foundation
import lit_networking

protocol ChatMediatorBuilder {
    static var shared: ClientMediator { get }
    static func buildMediator() -> ClientMediator
    func config(settings: ChatBuilderSettings)
}

struct ChatBuilderSettings {
    let email: String
    let travelerGuid: String
    let externalId: String
    let topId: String
    let subId: String
    let userId: String
    let accessTokenAdapter: AccessTokenAdapter
}

struct ChatDefaultComposition {
    
    static var manager = ChatDefaultComposition.makeManager()
    static let facade: ChatFacade = ChatFacade(mediator: ChatDefaultComposition.manager, conversation: SmoochConversation())
    
    private(set) static var settings: ChatBuilderSettings?
    
    private static func makeManager() -> ClientMediator {
        let smoochClient = SmoochChatClient()
        let httpClient = URLSessionHTTPClient()
        let storage = UserDefaultsStorage()
        let jwt = Jwt()
        let tokenAdapter = AccessTokenPingAdapter()
        
        let loaders = Loaders(http: httpClient, storage: storage, account: buildIdentityInfo(settings: settings))
        
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
    
    static func config(settings: ChatBuilderSettings) {
        ChatDefaultComposition.settings = settings
        ChatDefaultComposition.facade.settings(email: settings.email, tokenAdapter: settings.accessTokenAdapter)
    }
    
    private init() {} 
}

extension ChatDefaultComposition {
    private static func buildIdentityInfo(settings: ChatBuilderSettings?) -> IdentityInfo {
        let metadata = IdentityMetadata(type: "SMOOCH", travelerGUID: settings?.travelerGuid ?? "", externalID: settings?.externalId ?? "")
        let info = IdentityInfo(topId: settings?.topId ?? "", subId: settings?.subId ?? "", userId: settings?.userId ?? "", metadata: metadata)
        return info
    }
}

