//
//  ChatFacadeIntegrationTests.swift
//  Integration
//
//  Created by Mendy Edri on 11/02/2020.
//  Copyright © 2020 CWT. All rights reserved.
//

import XCTest
import TDDChatProject

class ChatFacadeIntegrationTests: XCTestCase {
    
    func test_chatFacade_showWehnReady() {
        let clients = Clients()
        clients.config(email: "de@yopmail.com")
        
        let exp = expectation(description: "Wait for showWhenReady to complete")
        var capturedResult = [ClientMediator.ClientState]()
        clients.facade.showWhenReady { result in
            capturedResult.append(result)
            exp.fulfill()
        }
        
        completeRemoteAppIdWithSuccess(mock: clients.httpClient, at: 0)
        completeRemoteVendorTokenWithSuccess(mock: clients.httpClient, at: 1)
        completeStartSDKWithSuccess(clients.chatClient)
        completeLoginSDKWithSuccess(clients.chatClient)
        
        wait(for: [exp], timeout: 3.0)
        XCTAssertEqual(clients.mockConversation.isConversationShowed, true)
        XCTAssertEqual(capturedResult, [.ready])
    }
}
