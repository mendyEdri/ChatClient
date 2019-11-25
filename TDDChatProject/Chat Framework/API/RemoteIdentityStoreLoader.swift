//
//  RemoteIdentityStoreLoader.swift
//  TDDChatProject
//
//  Created by Mendy Edri on 18/11/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import Foundation

public class RemoteIdentityStoreLoader {
    
    var client: ChatHTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case authFailed
        case alreadyRegistered
        case invalidData
    }
    
    public enum Result: Equatable {
        case success(IdentityStoreModel)
        case failure(Error)
    }
    
    public init(client: ChatHTTPClient) {
        self.client = client
    }
    
    public func load(from url: URL, completion: @escaping (Result) -> Void) {
        client.get(from: url) { result in
            
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
        
        if model.responseHeader.isRegister == true {
            return .failure(.alreadyRegistered)
        }
        
        return .success(model)
    }
}
