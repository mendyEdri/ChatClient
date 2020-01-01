//
//  HTTPClientRetryDecorator.swift
//  TDDChatProject
//
//  Created by Mendy Edri on 01/01/2020.
//  Copyright © 2020 CWT. All rights reserved.
//

import Foundation

public struct HTTPClientRetryDecorator: HTTPClientDecorator {
    
    private let httpClient: HTTPClient
    private let attempts: Int
    
    init(http client: HTTPClient, attempts: Int) {
        self.httpClient = client
        self.attempts = attempts
    }
    
    public func get(from url: URL, method: HTTPMethod, headers: [String : String]?, body: [String : String]?, completion: @escaping (HTTPClientRetryDecorator.Result) -> Void) {
        // ... todo
        
    }
}
