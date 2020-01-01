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

    func test_retry_canRetryDeliversFalseAfterReachedMaxRetries() {
        let sut = RetryExecutor(attempts: 3)
        
        XCTAssertTrue(sut.canRetry())
        
        sut.retried()
        sut.retried()
        sut.retried()
        
        XCTAssertFalse(sut.canRetry())
    }
    
    func test_retry_withZeroNonReturnsCanRetryAsTrue() {
        let sut = RetryExecutor(attempts: 0)
        
        XCTAssertFalse(sut.canRetry())
        
        sut.retried()
        sut.retried()
        
        XCTAssertFalse(sut.canRetry())
    }
    
    // MARK: Helpers
    
    private func anyError() -> Error {
        return NSError()
    }
    
    
    func test_protocols() {
        let accessTokenRetryNetworking = AccessTokenRetryNetworking()
        accessTokenRetryNetworking.get(url: "") {
            print("Done.")
        }
    }
}

protocol Networking {
    func get(url: String, complete: @escaping () -> Void)
}

struct NetworkingClient: Networking {
    func get(url: String, complete: () -> Void) {
        print("Networking Client")
        complete()
    }
}

protocol AccessTokenNetworking: Networking {}

extension AccessTokenNetworking {
    func getAccessToken(complete: (String) -> Void) {
        fetchingAccesToken(url: "https://access-token.com", complete: complete)
    }

    func fetchingAccesToken(url: String, complete: (String) -> Void) {
        print("Getting access token")
        sleep(2)
        complete("90320IQWEOQUA.12-10.090")
    }
}

protocol RetryNetworking: Networking {}

extension RetryNetworking {
    func retry(url: String, completion: @escaping () -> Void) {
        retryRequest(url: url, complete: completion)
    }
    
    func retryRequest(url: String, complete: () -> Void) {
        print("Got error")
        print("Retrying..")
        complete()
    }
}

struct AccessTokenRetryNetworking: Networking, AccessTokenNetworking, RetryNetworking {
    func get(url: String, complete: @escaping () -> Void) {
        
        var requestSuccess = false
        
        getAccessToken { token in
            print(token)
            if requestSuccess {
                complete()
            } else {
                retry(url: url, completion: complete)
                requestSuccess = true
            }
        }
    }
}
