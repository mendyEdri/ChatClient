//
//  IdentityStoreControllerTests.swift
//  TDDChatProjectTests
//
//  Created by Mendy Edri on 25/11/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import XCTest
@testable import TDDChatProject

class IdentityStoreControllerTests: XCTestCase {

    private var testSpecificUserIdKey = "\(type(of: self)).user-id"
    
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
        let exp = expectation(description: "Wait for start method to end")
        let expectedData = IdentityStoreResponseHelper.makeJsonItem().toData()
        
        sut.start { _ in
            exp.fulfill()
        }
        
        client.complete(withSatus: 200, data: expectedData)
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(storage.value(for: testSpecificUserIdKey) as? String, IdentityStoreResponseHelper.userId)
    }
    
    func test_start_notHittingNetworkWhenUserIdIsSaved() {
        let (sut, client, storage) = makeSUT()
        
        storage.save(value: anyUserID(), for: testSpecificUserIdKey)
        sut.start { _ in }
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
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
    
    private func makeSUT() -> (sut: IdentityStoreController, client: ChatHTTPClientMock, storage: UserDefaultsStorage) {
        
        let storage = UserDefaultsStorage()
        let client = ChatHTTPClientMock()
        
        let sut = IdentityStoreController(url: anyURL(), httpClient: client, store: (storage, testSpecificUserIdKey))
    
        return (sut, client, storage)
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
