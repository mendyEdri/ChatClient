//
//  IdentityStoreControllerTests.swift
//  TDDChatProjectTests
//
//  Created by Mendy Edri on 25/11/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import XCTest
import lit_networking
@testable import TDDChatProject

class IdentityStoreControllerTests: XCTestCase {
    
    private var testSpecificUserIdKey = "\(type(of: self)).user-id"
    private var testSpecificUserIdValue = "astro.world.2019"
    
    private typealias Result = IdentityStoreController.Result
    
    override func setUp() {
        super.setUp()
        setupEmptyStorageState()
    }
    
    override func tearDown() {
        super.tearDown()
        undoStorageSideEffects()
    }
    
    func test_start_saveIdOnSuccessResponse() {
        let (sut, client, storage) = makeSUT()
        
        let expectedData = IdentityStoreResponseHelper.makeJsonItem(testSpecificUserIdValue)
        
        start(sut, when: {
            client.complete(withSatus: 200, data: expectedData)
        }, assert: {
            XCTAssertEqual(storage.value(for: testSpecificUserIdKey) as? String, testSpecificUserIdValue)
        })
    }
    
    func test_start_savesUserIdOnAlreadyRegisterSuccessResponse() {
        let (sut, client, storage) = makeSUT()
        
        let expectedData = IdentityStoreResponseHelper.makeAlreadyRegisterJSON(testSpecificUserIdValue).toData()
        
        start(sut, when: {
            client.complete(withSatus: 200, data: expectedData)
        }, assert: {
            XCTAssertEqual(storage.value(for: testSpecificUserIdKey) as? String, testSpecificUserIdValue)
        })
    }
    
    func test_start_notHittingNetworkWhenUserIdIsSaved() {
        let (sut, client, storage) = makeSUT()
        
        storage.save(value: anyUserID(), for: testSpecificUserIdKey)
        sut.registerIfNeeded(tokenAdapter: AccessTokenMockAdapter()) { _ in }
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_start_notSavingWhenDeliveredNot200FromAPI() {
        let (sut, client, storage) = makeSUT()
        
        let jsonData = anyData()
        
        start(sut, when: {
            client.complete(withSatus: 401, data: jsonData)
        }, assert: {
            XCTAssertNil(storage.value(for: testSpecificUserIdKey))
        })
    }
    
    func test_clear_deletesCachedUserId() {
        let (sut, _, storage) = makeSUT()
        
        storage.save(value: anyUserID(), for: testSpecificUserIdKey)
        sut.clearUserId()
        
        XCTAssertTrue(sut.savedUserId() == nil)
    }
    
    func test_start_trackMemoryLeak() {
        let (sut, client, _) = makeSUT()
        
        trackMemoryLeaks(sut)
        trackMemoryLeaks(client)
    }
    
    // MARK: - Helpers
    
    private func start(_ sut: IdentityStoreController, when action: () -> Void, assert: () -> Void) {
        
        let exp = expectation(description: "Wait for start method to end")
        sut.registerIfNeeded(tokenAdapter: AccessTokenMockAdapter()) { _ in
            exp.fulfill()
        }
        action()
        
        wait(for: [exp], timeout: 1.0)
        assert()
    }
    
    private func makeSUT() -> (sut: IdentityStoreController, client: HTTPClientMock, storage: UserDefaultsStorage) {
        
        let storage = UserDefaultsStorage()
        let client = HTTPClientMock()
        
        let sut = IdentityStoreController(url: anyURL(), httpClient: client, identityInfo: IdentityStoreDataHelper.defaultIndetityInfo(), storage: storage, key: testSpecificUserIdKey)
        
        return (sut, client, storage)
    }
    
    private func anyData() -> Data {
        return IdentityStoreResponseHelper.makeJsonItem(testSpecificUserIdValue)
    }
    
    private func anyNSError() -> NSError {
        return NSError(domain: "chat.unit", code: 1, userInfo: nil)
    }
    
    private func anyURL() -> URL {
        return URL(string: "http://a-url.com")!
    }
    
    private func anyUserID() -> String {
        return "Greta.Thunberg"
    }
    
    private func setupEmptyStorageState() {
        deleteTestStorage()
    }
    
    private func undoStorageSideEffects() {
        deleteTestStorage()
    }
    
    private func deleteTestStorage() {
        let (_, _, storage) = makeSUT()
        storage.delete(key: testSpecificUserIdKey)
    }
}
