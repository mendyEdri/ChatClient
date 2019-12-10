//
//  DefaultStorageTests.swift
//  DefaultStorageTests
//
//  Created by Mendy Edri on 29/10/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import XCTest
@testable import TDDChatProject

class DefaultStorageTests: XCTestCase {

    private let testSpecificSavingKey = "unit.\(type(of: self))"
    
    override func tearDown() {
        super.tearDown()
        deleteSavedTestingValues()
    }
    
    override func setUp() {
        super.setUp()
        setUpWithCleanStore()
    }
    
    private func makeSUT() -> Storage {
        return UserDefaultsStorage()
    }

    func test_save_storageCanSaveString() {
        let sut = makeSUT()
        let valueToSave = "Monica Geller"
        let key = testSpecificSavingKey
        
        sut.save(value: valueToSave, for: key)
        
        XCTAssertEqual(sut.value(for: key) as! AnyHashable, valueToSave)
    }
    
    func test_save_storageCanDelete() {
        let sut = makeSUT()
        
        let valueToSave = "Chandler Bing"
        let key = testSpecificSavingKey
        
        sut.save(value: valueToSave, for: key)
        XCTAssertTrue(sut.hasValue(for: key))
        
        sut.delete(key: key)
        XCTAssertFalse(sut.hasValue(for: key))
    }
    
    func test_save_overridesPreviouslySavedValues() {
        let sut = makeSUT()
        let key = testSpecificSavingKey
        
        let firstInsertedValue = "Chandler Bing"
        
        sut.save(value: firstInsertedValue, for: key)
        XCTAssertTrue(sut.hasValue(for: key))
        
        let secondInsertedValue = "Ross Geller"
        sut.save(value: secondInsertedValue, for: key)
        
        XCTAssertEqual(sut.value(for: key) as? String, secondInsertedValue)
    }
    
    // MARK: - Helpers
    
    private func setUpWithCleanStore() {
        delete()
    }
    
    private func deleteSavedTestingValues() {
        delete()
    }
    
    private func delete() {
        let sut = makeSUT()
        sut.delete(key: testSpecificSavingKey)
    }
}
