//
//  IdentityStoreIntegrationTests.swift
//  Integration
//
//  Created by Mendy Edri on 15/01/2020.
//  Copyright © 2020 CWT. All rights reserved.
//

import XCTest
@testable import TDDChatProject
import lit_networking

class IdentityStoreIntegrationTests: XCTestCase {
    
    func NOtest_identityStoreIsSavedOnSuccess() {
        let (manager, clients) = makeManager()
        
        let exp = expectation(description: "Wait for chat prepare to complete")
        manager.prepare { _ in
            exp.fulfill()
        }
        
        clients.chatClient.toMockClient()?.completeStartSDKSuccessfuly()
        
        wait(for: [exp], timeout: 10.0)

        XCTAssertTrue(clients.storage.hasValue(for: storageKey))
    }
    
    // Helpers
    
    private func makeManager() -> (ClientMediator, ClientMediatorClients) {
        let chatClient = ChatClientSpy()
        let httpClient = HTTPClientMock()
        let storage = UserDefaultStorageMock()
        let jwt = Jwt()
        
        let strategy = TokenBasedClientStrategy(client: chatClient, storage: storage, jwt: jwt)
        
        let managerClients = ClientMediatorClients(
            chatClient: chatClient,
            httpClient: httpClient,
            jwtClient: jwt,
            storage: storage,
            strategy: strategy)
        
        return (ClientMediator(clients: managerClients), managerClients)
    }
}

extension HTTPClient {
    func toMockClient() -> HTTPClientMock? {
        return self as? HTTPClientMock
    }
}

extension ChatClient {
    func toMockClient() -> ChatClientSpy? {
        return self as? ChatClientSpy
    }
}

extension IdentityStoreIntegrationTests {
    private var storageKey: String {
        return "IdentityStoreIntegrationTests"
    }
    
    private var invalidStorageKey: String {
        return "--###--"
    }
}