//
//  RemoteIdentityStoreLoader.swift
//  TDDChatProject
//
//  Created by Mendy Edri on 18/11/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import Foundation
import lit_networking

public class RemoteIdentityStoreLoader {
    
    var client: HTTPClient
    private let url: URL
    
    public enum Error: Swift.Error {
        case connectivity
        case authFailed
        case invalidData
    }
    
    public typealias Result = Swift.Result<IdentityStoreModel, Error>
    
    public init(url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url, method: .GET) { result in
            
            switch result {
            case let .success(data, response):
                completion(IdentityStoreModelMapper.map(from: data, from: response))
                
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}

private struct IdentityStoreModelMapper {
    
    private static var OK_200: Int { 200 }
    private static var failed_401: Int { 401 }
    
    static func map(from data: Data, from response: HTTPURLResponse) -> RemoteIdentityStoreLoader.Result {
        
        guard response.statusCode == OK_200,
            let model = try? JSONDecoder().decode(IdentityStoreModel.self, from: data) else {
                if response.statusCode == failed_401 {
                    return .failure(RemoteIdentityStoreLoader.Error.authFailed)
                } else {
                    return .failure(RemoteIdentityStoreLoader.Error.invalidData)
                }
        }
        
        return .success(model)
    }
}
