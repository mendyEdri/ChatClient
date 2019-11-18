//
//  ChatHTTPClientMock.swift
//  ChatHTTPLoaderTests
//
//  Created by Mendy Edri on 05/11/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import Foundation
@testable import TDDChatProject

internal class ChatHTTPClientMock: ChatHTTPClient {
    
    private var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()
    
    // MARK: Implementation
    
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
        messages.append((url, completion))
    }
    
    // MARK: Helpers
    
    var requestedURLs: [URL] {
        return messages.map { $0.url }
    }
    
    // MARK: Mock
    
    func complete(with error: Error, at index: Int = 0) {
        messages[index].completion(.failure(error))
    }
    
    func complete(withSatus code: Int, data: Data, at index: Int = 0) {
        let response = HTTPURLResponse(url: messages[index].url,
                                       statusCode: code,
                                       httpVersion: nil,
                                       headerFields: nil)!
        
        messages[index].completion(.success(data, response))
    }
}

