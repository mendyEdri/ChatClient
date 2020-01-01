//
//  RetryExecutorTests.swift
//  TDDChatProjectTests
//
//  Created by Mendy Edri on 22/12/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import XCTest
import TDDChatProject

class RetryExecutorTests: XCTestCase {

    func test_retry_canRetryExecuteRetries() {
        
        var counter = 0
        let sut = RetryExecutor(attempts: 3) {
            counter += 1
        }!
        
        sut.retry()
        sut.retry()
        sut.retry()
        
        XCTAssertTrue(counter == 3)
    }
    
    func test_retry_withZeroNonReturnsWontCallBlock() {
    
        var sut = RetryExecutor(attempts: 0) {}
        XCTAssertNil(sut)
        
        sut = RetryExecutor(attempts: -2) {}
        XCTAssertNil(sut)
        
        sut = RetryExecutor(attempts: 1) {}
        XCTAssertNotNil(sut)
    }
    
    func test_retry_executesMaxTimesAndNotMore() {
        
        var counter = 0
        let sut = RetryExecutor(attempts: 2) {
            counter += 1
        }!
        
        sut.retry()
        sut.retry()
        sut.retry()
        sut.retry()
        
        XCTAssertTrue(counter == 2)
    }
    
    // MARK: Helpers
    
    private func anyError() -> Error {
        return NSError()
    }
}

