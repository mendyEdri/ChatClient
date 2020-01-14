//
//  HTTPClientRetryDecoratorTests.swift
//  TDDChatProjectTests
//
//  Created by Mendy Edri on 01/01/2020.
//  Copyright © 2020 CWT. All rights reserved.
//

import XCTest
import TDDChatProject

class HTTPClientRetryDecoratorTests: XCTestCase {
    
    func test_decoratorRetryOnlyExactTimesAsTheAttempts() {
        let mock = HTTPClientMock()
        expect(attempts: 4, mock: mock) {
            mock.complete(with: self.anyError)
        }
    }
    
    func test_expectAttemptOnce() {
        let mock = HTTPClientMock()
        expect(attempts: 1, mock: mock) {
            mock.complete(with: self.anyError)
        }
    }
    
    func test_expect99Times() {
        let mock = HTTPClientMock()
        expect(attempts: 99, mock: mock) {
            mock.complete(with: self.anyError)
        }
    }
    
    // Mark: Helper
    
    private func expect(attempts: Int, mock: HTTPClientMock, onRetry: @escaping () -> Void) {
    
        let retryable = RetryNotify(attempts: attempts)!
        let client = HTTPClientRetryDecorator(http: mock, retryable: retryable)
        
        var counter = 0
        let exp = expectation(description: "Wait for retry to end")
        
        retryable.onRetry = {
            counter += 1
            onRetry()
        }
        
        client.get(from: anyURL) { _ in
            exp.fulfill()
        }
        mock.complete(with: self.anyError)

        wait(for: [exp], timeout: 2.0)
        XCTAssertEqual(counter, attempts)
    }
}

private extension HTTPClientRetryDecoratorTests {
    var anyURL: URL {
        return URL(string: "https://a-url.nl")!
    }
    
    var anyMethod: HTTPMethod {
        return .UPDATE
    }
    
    var anyError: NSError {
        return NSError()
    }
}
