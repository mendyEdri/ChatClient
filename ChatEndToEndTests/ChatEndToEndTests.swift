//
//  ChatEndToEndTests.swift
//  ChatEndToEndTests
//
//  Created by Mendy Edri on 12/12/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import XCTest
import lit_networking
import Smooch
@testable import TDDChatProject

class ChatEndToEndTests: XCTestCase {
    
    var accessToken: String? = nil
    
    private let timeout = 20.0
    
    override func setUp() {
        super.setUp()
        cleanUp()
    }
    
    override func tearDown() {
        super.tearDown()
        cleanUp()
    }
    
    func test_client_init() {
        Smooch.destroy()
        
        let exp = expectation(description: "Wait for smooch to be initialized")
        var answer = false
                
        ChatDefaultComposition.manager.startSDK(for: (SmoochChatClient(), "5c0176f943aea6002248a53b")) { result in
            if case .success = result {
                answer = true
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 15.0)
        
        XCTAssertTrue(answer)
    }
    
    func test_prepareSDK_deliverReadyStateWhenNoAppIdOrTokenSaved() {
        expectState(toBe: .ready)
    }
    
    func test_prepareSDK_deliverReadyStateWhenAppIdIsSavedAndTokenIsNotSaved() {
        saveRealAppId()
        
        expectState(toBe: .ready)
    }
    
    func test_prepareSDK_deliverReadyStateRecoverFromInvalidAppIdIsSaved() {
        saveInvalidAppId()
        
        expectState(toBe: .ready)
    }
    
    func test_preparteSDK_deliverReadyRecoveringFromInvalidUserToken() {
        saveInvalidToken()
        
        expectState(toBe: .ready)
    }
    
    func test_prepareSDK_deliverReadyRecoveringFromExpiredUserToken() {
        saveExpiredToken()
        
        expectState(toBe: .ready)
    }
    
    func test_renewUserToken_deliversReady() {
        saveRealAppId()
        saveExpiredToken()
        
        let exp = expectation(description: "Wait for chat to be prepared")
        var capturedResult: ClientMediator.Result = .failure(.failedFetchToken)
        
        ChatDefaultComposition.managerWithHardCodedUser.renewUserToken { result in
            capturedResult = result
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: timeout)
        XCTAssertTrue(capturedResult.succeeded)
    }
    
    func not_yet_test_prepareSDK_processMesure() {
        measure {
            let exp = expectation(description: "Wait for chat to be prepared")
            ChatDefaultComposition.manager.prepare { result in
                exp.fulfill()
            }
            wait(for: [exp], timeout: timeout)
        }
    }
    
    func test_tokenForTestingOnlyWithHardCodedUser() {
        /** If this is breaks, could be the hard-coded user
         has and issue such as password got change or user has being blocked */
        let loader = AccessTokenSpyRemoteAdapter()
        let exp = expectation(description: "accessToken")

        var capturedResult = [Result<String, Error>]()
        loader.requestAccessToken { (result) in
            capturedResult.append(result)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: timeout)
        XCTAssertTrue(capturedResult.first!.succeeded)
    }
    
    // MARK - Helpers
    
    private func expectState(toBe state: ClientMediator.ClientState, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for chat to be prepared")
        var capturedResult = [ClientMediator.ClientState]()
        
        ChatDefaultComposition.managerWithHardCodedUser.prepare { result in
            capturedResult.append(result)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: timeout)
        XCTAssertEqual(capturedResult, [state], file: file, line: line)
    }
}

extension ChatEndToEndTests {
    func saveRealAppId() {
        let storage = UserDefaultsStorage()
        storage.save(value: "5c0176f943aea6002248a53b", for: SmoochChatClient().appIdKey)
    }
    
    func saveInvalidAppId() {
        let storage = UserDefaultsStorage()
        storage.save(value: "INVALID_APP_ID", for: SmoochChatClient().appIdKey)
    }
    
    func saveInvalidToken() {
        let storage = UserDefaultsStorage()
        storage.save(value: "INVALID_TOKEN", for: SmoochChatClient().userTokenKey)
    }
    
    func saveExpiredToken() {
        let storage = UserDefaultsStorage()
        storage.save(value: expiredToken, for: SmoochChatClient().userTokenKey)
    }
}

extension ChatEndToEndTests {
    
    private func cleanUp() {
        deleteAppId()
        deleteUserToken()
        clientLogout()
    }
    
    private func deleteAppId() {
        let storage = UserDefaultsStorage()
        storage.delete(key: SmoochChatClient().appIdKey)
    }
    
    private func deleteUserToken() {
        let storage = UserDefaultsStorage()
        storage.delete(key: SmoochChatClient().userTokenKey)
    }
    
    private func clientLogout() {
        ChatDefaultComposition.manager.logout { _ in }
    }
}

extension ChatEndToEndTests {
    private var expiredToken: String {
        return "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyLCJleHAiOjExNzI2MTExNzcsImlkIjoicGluZ0lkMTIzNCIsInVzZXJJZCI6InVzZXJJZDk4NzYifQ.PHdCsv40vXi56McA3084aDkVeuIkOlAK5Jm2_IU8Io8"
    }
}

extension ChatDefaultComposition {
    
    fileprivate static let managerWithHardCodedUser = makeManager(tokenAdapter: AccessTokenSpyRemoteAdapter())
    
    fileprivate static func makeManager(tokenAdapter: AccessTokenAdapter = AccessTokenSpyRemoteAdapter()) -> ClientMediator {
        let smoochClient = SmoochChatClient()
        let httpClient = URLSessionHTTPClient()
        let storage = UserDefaultsStorage()
        let jwt = Jwt()
        
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
}
