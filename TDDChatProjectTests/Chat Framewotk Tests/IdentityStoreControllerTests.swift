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
    
    func test_load_saveIDonSuccessResponse() {
        let sut = makeSUT()
        
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> IdentityStoreController {
        return IdentityStoreController(url: anyURL(), httpClient: ChatHTTPClientMock(), storage: UserDefaultsStorage())
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
