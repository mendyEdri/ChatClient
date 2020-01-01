//
//  HTTPClientRetryDecorator.swift
//  TDDChatProject
//
//  Created by Mendy Edri on 01/01/2020.
//  Copyright © 2020 CWT. All rights reserved.
//

import Foundation

public class HTTPClientRetryDecorator: HTTPClientDecorator {
    
    private let httpClient: HTTPClient
    private let attempts: Int
    private var retrier: RetryExecutor?
    
    init(http client: HTTPClient, attempts: Int) {
        self.httpClient = client
        self.attempts = attempts
    }
    
    public func get(from url: URL, method: HTTPMethod, headers: [String : String]?, body: [String : String]?, completion: @escaping (HTTPClientRetryDecorator.Result) -> Void) {
        
        retrier = RetryExecutor(attempts: attempts) { [weak self] in
            self?.clientCall(from: url, method: method, headers: headers, body: body, completion: completion)
        }
    }
    
    // Mark: Helpers
    
    private func clientCall(from url: URL, method: HTTPMethod, headers: [String: String]?, body: [String: String]?, completion: @escaping (HTTPClientRetryDecorator.Result) -> Void) {
        
        httpClient.get(from: url, method: method, headers: headers, body: body) { [weak self] result in
            guard let self = self else { return }
            
            completion(self.handle(client: result))
        }
    }
    
    private func handle(client result: HTTPClientRetryDecorator.Result) -> HTTPClientRetryDecorator.Result {
        if case let .failure(error) = result, retrier?.retry() == false {
            return .failure(error)
        }
        return result
    }
}
