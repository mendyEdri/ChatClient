//
//  RemoteAppIdLoader.swift
//  ChatHTTPLoader
//
//  Created by Mendy Edri on 30/10/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import Foundation

/** Loads the STS Metadata request */

public class RemoteAppIdLoader {
    private let url: URL
    private let client: ChatHTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public enum Result: Equatable {
        case success(ChatVendorAppId)
        case failure(Error)
    }
    
    public init(url: URL, client: ChatHTTPClient) {
        self.url = url
        self.client = client
    }
        
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { result in
            
            switch result {
            case let .success(data, response):
                completion(ChatVendorAppIdMapper.map(data: data, from: response))
                
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}

struct ChatVendorAppIdMapper {
        
    private static var OK_200: Int { 200 }
    
    internal static func map(data: Data, from response: HTTPURLResponse) -> RemoteAppIdLoader.Result {
        guard response.statusCode == OK_200,
        let vendorAppId = try? JSONDecoder().decode(ChatVendorAppId.self, from: data) else {
            return .failure(.invalidData)
        }
        return .success(vendorAppId)
    }
}
