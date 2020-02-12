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
        return MediatorsRetry.httpRetryAttempts
    }
    
    static var sdkRetryAttempts: Int {
        return MediatorsRetry.sdkRetryAttempts
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
    // MARK: - Testing Prepare function with fails and retry to verify integration between HTTPClientRetryDecorator and other components
    
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
    
    func test_prepare_deliversRemoteTokenFailedAfterRetryAndFailed() {
        let (sut, clients, httpAttempts, _) = sutSetup()

        expect(sut: sut, be: .failed(.failedFetchToken), when: {
            completeRemoteAppIdWithSuccess(mock: clients.httpClient)
            
            httpAttempts.loop { index in
                completeRemoteVendorTokenWithError(mock: clients.httpClient, at: index + 1)
            }
        })
    }
    
    func test_prepare_deliversRemoteTokenSuccessAfterRetryAndSuccess() {
        let (sut, clients, httpAttempts, _) = sutSetup()
        
        expect(sut: sut, be: .ready, when: {
            completeRemoteAppIdWithSuccess(mock: clients.httpClient)
            
            var count = 0
            (httpAttempts - 1).loop { index in
                count += 1
                completeRemoteVendorTokenWithError(mock: clients.httpClient, at: index + 1)
            }
            completeRemoteVendorTokenWithSuccess(mock: clients.httpClient, at: count)
            
            completeStartSDKWithSuccess(clients.chatClient)
            completeLoginSDKWithSuccess(clients.chatClient)
        })
    }
}

extension ClientMediatorIntegrationTests {
    // MARK: - Renew Token Tests
    
    func test_renewToken_deliversSuccessAfterExpiredTokenWasSaved() {
        let clients = Clients()
        let sut = clients.makeManager()
        
        expectRenew(sut: sut, be: .success(JSONMockData.validChatVendorToken.accessToken), when: {
            completeRemoteVendorTokenWithSuccess(mock: clients.httpClient)
        })
    }
    
    func test_renewToken_deliversFailureAfterExceededMaxAttempts() {
        let (sut, clients, httpAttempts, _) = sutSetup()
        
        expectRenew(sut: sut, be: .failure(.failedFetchToken), when: {
            httpAttempts.loop {
                completeRemoteVendorTokenWithError(mock: clients.httpClient)
            }
        })
    }
    
    func test_renewToken_deliversSuccessAfterRetryLessThenMaxAttempts() {
        let (sut, clients, httpAttempts, _) = sutSetup()
        
        expectRenew(sut: sut, be: .success(JSONMockData.validChatVendorToken.accessToken), when: {
            (httpAttempts - 1 as Int).loop {
                completeRemoteVendorTokenWithError(mock: clients.httpClient)
            }
            completeRemoteVendorTokenWithSuccess(mock: clients.httpClient)
        })
    }
}

extension ClientMediatorIntegrationTests {
    // MARK: - Helpers
    
    private func expect(sut: ClientMediator, be expected: ClientMediator.ClientState, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for prepare to complete")
        
        var capturedResult = [ClientMediator.ClientState]()
        sut.prepare { result in
            capturedResult.append(result)
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 5.0)
        
        XCTAssertEqual(capturedResult, [expected], file: file, line: line)
    }
    
    private func expectRenew(sut: ClientMediator, be expected: ClientMediator.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        
        let exp = expectation(description: "Wait for renew token to complete")
        var capturedResult = [ClientMediator.Result]()
        sut.renewUserToken { result in
            capturedResult.append(result)
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 3.0)
        XCTAssertEqual(capturedResult, [expected], file: file, line: line)
    }
    
    private func sutSetup() -> (sut: ClientMediator, clients: Clients, httpRetryAttempts: Int, sdkRetryAttempts: Int) {
        let clients = Clients()
        let sut = clients.makeManager()
        return (sut, clients, ClientMediatorIntegrationTests.httpRetryAttempts, ClientMediatorIntegrationTests.sdkRetryAttempts)
    }
}
