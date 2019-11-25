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

    override func setUp() {
        super.setUp()
        setupEmptyStorageState()
    }
    
    override func tearDown() {
        super.tearDown()
        undoStorageSideEffects()
    }
    
    func test_load_saveIdOnSuccessResponse() {
        let (sut, client, _) = makeSUT()
        let chatPersistent = ChatPersistent(storage: UserDefaultsStorage())
        let exp = expectation(description: "Wait for start method to end")
        let expectedData = IdentityStoreResponseHelper.makeJsonItem().toData()
        
        sut.start {
            exp.fulfill()
        }
        
        client.complete(withSatus: 200, data: expectedData)
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(chatPersistent.getVendorUserId(), IdentityStoreResponseHelper.userID)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: IdentityStoreController, client: ChatHTTPClientMock, storage: UserDefaultsStorage) {
        let storage = UserDefaultsStorage()
        let client = ChatHTTPClientMock()
        let sut = IdentityStoreController(url: anyURL(), httpClient: client, storage: storage)
        return (sut, client, storage)
    }
    
    private func anyURL() -> URL {
        return URL(string: "http://a-url.com")!
    }
        
    private func setupEmptyStorageState() {
        deleteTestStorage()
    }
    
    private func undoStorageSideEffects() {
        deleteTestStorage()
    }
    
    private func deleteTestStorage() {
        let persistent = ChatPersistent(storage: UserDefaultsStorage())
        persistent.deleteVendorUserId()
    }
}
