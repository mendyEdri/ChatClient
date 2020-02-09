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
        
    func test_identityStoreIsSavedOnPrepareSuccess() {
        let clients = Clients()
        let sut = clients.makeManager()
        
        let exp = expectation(description: "wait for prepare to complete")
            
        sut.prepare { result in
            exp.fulfill()
        }
        
        completeRemoteAppIdWithSuccess(mock: clients.httpClient)
        completeRemoteVendorTokenWithSuccess(mock: clients.httpClient, at: 1)
        completeStartSDKWithSuccess(clients.chatClient)
        completeLoginSDKWithSuccess(clients.chatClient)
        completeRemoteIdentityStoreWithSuccess(mock: clients.httpClient, at: 2)
        
        wait(for: [exp], timeout: 2.0)
        XCTAssertNotNil(clients.storage.value(for: "IdentityStoreController.identityStoreKey"))
    }
    
    // Helpers
    
    private func makeManager() -> (ClientMediator, ClientMediatorClients) {
        let chatClient = ChatClientSpy()
        let httpClient = HTTPClientMock()
        let tokenAdapter = AccessTokenMockAdapter()
        let storage = UserDefaultStorageMock()
        let jwt = Jwt()
        
        let strategy = TokenBasedClientStrategy(client: chatClient, storage: storage, jwt: jwt)
        
        let managerClients = ClientMediatorClients(
            chatClient: chatClient,
            httpClient: httpClient,
            tokenAdapter: tokenAdapter,
            jwtClient: jwt,
            storage: storage,
            strategy: strategy)
        
        return (ClientMediator(clients: managerClients), managerClients)
    }
}

private extension IdentityStoreIntegrationTests {
    func completeRemoteIdentityStoreWithSuccess(mock: HTTPClientMock, at index: Int = 0) {
        mock.complete(withSatus: 200, data: JSONMockData.identityStoreRemoteApiData(), at: index)
    }
}
