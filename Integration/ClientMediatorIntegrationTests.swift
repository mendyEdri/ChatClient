//
//  ClientMediatorTest.swift
//  Integration
//
//  Created by Mendy Edri on 15/01/2020.
//  Copyright © 2020 CWT. All rights reserved.
//

import XCTest
import lit_networking
import TDDChatProject

class ClientMediatorIntegrationTests: XCTestCase {
    
    static var httpRetryAttempts: Int {
        return ClientMediator.httpRetryAttempts
    }
    
    static var sdkRetryAttempts: Int {
        return ClientMediator.sdkRetryAttempts
    }
    
    func test_prepare_deliversReadyOnTokenValid() {
        let (sut, clients, _, _) = sutSetup()
        
        expect(sut: sut, be: .ready, when: {
            completeRemoteAppIdWithSuccess(mock: clients.httpClient)
            completeRemoteVendorTokenWithSuccess(mock: clients.httpClient, at: 1)
            
            completeStartSDKWithSuccess(clients.chatClient)
            completeLoginSDKWithSuccess(clients.chatClient)
        })
    }
    
    func test_prepare_deliversAppIdFailsOnRemoteAppIdRequestFails() {
        let (sut, clients, attempts, _) = sutSetup()
        
        expect(sut: sut, be: .failed(.failedFetchAppId), when: {
            attempts.loop {
                completeRemoteAppIdWithError(mock: clients.httpClient)
            }
        })
    }
    
    func test_prepare_deliversVendorTokenFailsWhenTokenRequestFails() {
        let (sut, clients, attempts, _) = sutSetup()

        expect(sut: sut, be: .failed(.failedFetchToken), when: {
            completeRemoteAppIdWithSuccess(mock: clients.httpClient)
            attempts.loop {
                completeRemoteVendorTokenWithError(mock: clients.httpClient, at: 1)
            }
        })
    }
    
    func test_prepare_deliversStartSDKFailsWhenClientSDKStartFails() {
        let (sut, clients, _, sdkAttempts) = sutSetup()
        
        expect(sut: sut, be: .failed(.initFailed), when: {
            completeRemoteAppIdWithSuccess(mock: clients.httpClient)
            completeRemoteVendorTokenWithSuccess(mock: clients.httpClient, at: 1)
            
            sdkAttempts.loop {
                completeStartSDKWithError(clients.chatClient)
            }
        })
    }
    
    func test_prepare_deliversLoginSDKFailsWhenClientSDKLoginFails() {
        let (sut, clients, _, sdkAttempts) = sutSetup()
        
        expect(sut: sut, be: .failed(.loginFailed), when: {
            completeRemoteAppIdWithSuccess(mock: clients.httpClient)
            completeRemoteVendorTokenWithSuccess(mock: clients.httpClient, at: 1)
            completeStartSDKWithSuccess(clients.chatClient)
            
            sdkAttempts.loop {
                completeLoginSDKWithError(clients.chatClient)
            }
        })
    }
}

extension ClientMediatorIntegrationTests {
    // MARK: Testing Prepare function with fails and retry to verify integration between HTTPClientRetryDecorator and other components
    
    func test_prepare_deliversReadyOnAppIdFetchFailsAndRetryWithSuccess() {
        let clients = Clients()
        let sut = clients.makeManager()
        
        expect(sut: sut, be: .ready, when: {
            completeRemoteAppIdWithError(mock: clients.httpClient, at: 0)
            
            // Retry completions
            completeRemoteAppIdWithSuccess(mock: clients.httpClient, at: 1)
            completeRemoteVendorTokenWithSuccess(mock: clients.httpClient, at: 2)
            
            completeStartSDKWithSuccess(clients.chatClient)
            completeLoginSDKWithSuccess(clients.chatClient)
        })
    }
    
    func test_prepare_deliversReadyOnTokenFetchFailsAndRetryWithSuccess() {
        let clients = Clients()
        let sut = clients.makeManager()
        
        expect(sut: sut, be: .ready, when: {
            completeRemoteAppIdWithSuccess(mock: clients.httpClient, at: 0)
            
            // Intentially fails
            completeRemoteVendorTokenWithError(mock: clients.httpClient, at: 1)
            // Now, let's try to retry and make it work
            completeRemoteVendorTokenWithSuccess(mock: clients.httpClient, at: 2)
            
            completeStartSDKWithSuccess(clients.chatClient)
            completeLoginSDKWithSuccess(clients.chatClient)
        })
    }
}

extension ClientMediatorIntegrationTests {
    // MARK: Helpers
    
    private func expect(sut: ClientMediator, be expected: ClientMediator.ClientState, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for prepare to complete")
        
        var capturedResult = [ClientMediator.ClientState]()
        sut.prepare { result in
            capturedResult.append(result)
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 10.0)
        
        XCTAssertEqual(capturedResult, [expected], file: file, line: line)
    }
    
    private func sutSetup() -> (sut: ClientMediator, clients: Clients, httpRetryAttempts: Int, sdkRetryAttempts: Int) {
        let clients = Clients()
        let sut = clients.makeManager()
        return (sut, clients, ClientMediatorIntegrationTests.httpRetryAttempts, ClientMediatorIntegrationTests.sdkRetryAttempts)
    }
}

private extension ClientMediatorIntegrationTests {
    // MAKR: Helpers methods to ease the complete HTTPClient requests
    func completeRemoteAppIdWithSuccess(mock: HTTPClientMock, at index: Int = 0) {
        mock.complete(withSatus: 200, data: JSONMockData.appIdRemoteApiData().toData(), at: index)
    }
    
    func completeRemoteAppIdWithError(mock: HTTPClientMock, at index: Int = 0) {
        mock.complete(with: anyError, at: index)
    }
    
    func completeRemoteVendorTokenWithSuccess(mock: HTTPClientMock, at index: Int = 0) {
        mock.complete(withSatus: 200, data: JSONMockData.vendorTokenRemoteApiData().toData(), at: index)
    }
    
    func completeRemoteVendorTokenWithError(mock: HTTPClientMock, at index: Int = 0) {
        mock.complete(with: anyError, at: index)
    }
    
    var anyError: Error {
        return NSError(domain: "cwt", code: 400, userInfo: nil)
    }
}

private extension ClientMediatorIntegrationTests {
    // MAKR: Helpers methods to ease the complete ChatClient methods
    func completeStartSDKWithSuccess(_ spy: ChatClientSpy) {
        spy.completeStartSDKSuccessfuly()
    }
    
    func completeStartSDKWithError(_ spy: ChatClientSpy) {
        spy.completeStartSDKWithError()
    }
    
    func completeLoginSDKWithSuccess(_ spy: ChatClientSpy) {
        spy.completeLoginSuccessfuly()
    }
    
    func completeLoginSDKWithError(_ spy: ChatClientSpy) {
        spy.completeLoginWithError()
    }
}

private class Clients {
    let chatClient = ChatClientSpy()
    let httpClient = HTTPClientMock()
    lazy var retryDecorator = HTTPClientRetryDecorator(http: self.httpClient, retryable: RetryExecutor(attempts: ClientMediatorIntegrationTests.httpRetryAttempts)!)
    
    let storage = UserDefaultStorageMock()
    let jwt = Jwt()
    
    func makeManager() -> ClientMediator {
        let strategy = TokenBasedClientStrategy(client: chatClient, storage: storage, jwt: jwt)
        
        let managerClients = ClientMediatorClients(
            chatClient: chatClient,
            httpClient: retryDecorator,
            jwtClient: jwt,
            storage: storage,
            strategy: strategy)
        
        return ClientMediator(clients: managerClients)
    }
}

extension Int {
    func loop(_ action: () -> Void) {
        for _ in 0...self {
            action()
        }
    }
}

