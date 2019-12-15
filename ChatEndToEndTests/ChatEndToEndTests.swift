//
//  ChatEndToEndTests.swift
//  ChatEndToEndTests
//
//  Created by Mendy Edri on 12/12/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import XCTest
import TDDChatProject

class ChatEndToEndTests: XCTestCase {

    func test_prepareSDK_deliverReadyState() {
        let exp = expectation(description: "Wait for chat to be prepared")
        var capturedResult = [ClientManager.ClientState]()
                
        ChatDefaultComposition.manager.prepare { result in
            capturedResult.append(result)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 10.0)
        XCTAssertEqual(capturedResult, [.failed])
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
}


