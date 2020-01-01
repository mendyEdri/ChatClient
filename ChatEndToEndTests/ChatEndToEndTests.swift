//
//  ChatEndToEndTests.swift
//  ChatEndToEndTests
//
//  Created by Mendy Edri on 12/12/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import XCTest
@testable import TDDChatProject

class ChatEndToEndTests: XCTestCase {
    
    var accessToken: String? = nil
    
    override func setUp() {
        super.setUp()
        cleanUp()
    }
    
    override func tearDown() {
        super.tearDown()
        cleanUp()
    }
    
    private func wrapWithToken(_ action: @escaping (String?) -> Void) {
        guard isTokenValid() == true else { return action(accessToken) }
            
        let loader = RemoteAccessTokenLoader(url: AccessTokenLoaderURL.prod.url, client: URLSessionHTTPClient())
        loader.load { [weak self] result in
            if case let .success(token) = result {
                self?.accessToken = token.accessToken
                action(token.accessToken)
            }
        }
    }
    
    private func isTokenValid() -> Bool {
        var expired: Bool?
        if let token = accessToken {
            let jwt = Jwt(string: token, parser: JwtDefaultParser())
            expired = try? jwt.isJwtExp()
        }
        return expired ?? false
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
    
    func test_prepareSDK_processMesure() {
        measure {
            let exp = expectation(description: "Wait for chat to be prepared")
            ChatDefaultComposition.manager.prepare { result in
                exp.fulfill()
            }
            wait(for: [exp], timeout: 10.0)
        }
    }
    
    // MARK - Helpers
    
    private func expectState(toBe state: ClientMediator.ClientState, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for chat to be prepared")
        var capturedResult = [ClientMediator.ClientState]()
                
        ChatDefaultComposition.manager.prepare { result in
            capturedResult.append(result)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 10.0)
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
    }
    
    private func deleteAppId() {
        let storage = UserDefaultsStorage()
        storage.delete(key: SmoochChatClient().appIdKey)
    }
    
    private func deleteUserToken() {
        let storage = UserDefaultsStorage()
        storage.delete(key: SmoochChatClient().userTokenKey)
    }
}

extension ChatEndToEndTests {
    private var expiredToken: String {
        return "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyLCJleHAiOjExNzI2MTExNzcsImlkIjoicGluZ0lkMTIzNCIsInVzZXJJZCI6InVzZXJJZDk4NzYifQ.PHdCsv40vXi56McA3084aDkVeuIkOlAK5Jm2_IU8Io8"
    }
}


