//
//  ChatDefaultComposition.swift
//  TDDChatProject
//
//  Created by Mendy Edri on 10/12/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import Foundation

enum ChatDefaultComposition {
    public static var manager = makeManager()
    
    private static func makeManager() -> ClientManager {
        let smoochClient = SmoochChatClient()
        let httpClient = URLSessionHTTPClient()
        let storage = UserDefaultsStorage()
        let jwt = Jwt()
        
        let strategy = TokenBasedClientStrategy(client: smoochClient, storage: storage, jwt: jwt)
        
        let managerClients = ClientManagerClients(
            chatClient: smoochClient,
            httpClient: httpClient,
            jwtClient: jwt,
            storage: storage,
            strategy: strategy)
    
        return ClientManager(clients: managerClients)
    }
}
