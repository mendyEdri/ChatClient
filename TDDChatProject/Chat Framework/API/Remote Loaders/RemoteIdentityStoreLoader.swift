//
//  RemoteIdentityStoreLoader.swift
//  TDDChatProject
//
//  Created by Mendy Edri on 18/11/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import Foundation
import lit_networking

final public class RemoteIdentityStoreLoader {
    
    var client: HTTPClient
    private let url: URL
    
    private var tokenDecorator: HTTPClientAccessTokenDecorator?
    private var retryDecorator: HTTPClientRetryDecorator
    private var retry = RetryExecutor(attempts: 2)!
    
    public enum Error: Swift.Error {
        case connectivity
        case authFailed
        case invalidData
        case serverError
    }
    
    public typealias Result = Swift.Result<IdentityStoreModel, Error>
    
    public init(url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
        self.tokenDecorator = nil
        self.retryDecorator = HTTPClientRetryDecorator(http: client, retryable: retry)
    }
    
    public func load(with tokenAdapter: AccessTokenAdapter, for account: IdentityInfo, completion: @escaping (Result) -> Void) {
        let headers = ["Content-Type": "application/json", "cwt-auth-provider": "pingFed", "cwt-client-id": "CwtToGoOauthClient"]
        let data = try? JSONEncoder().encode(account)

        tokenDecorator = HTTPClientAccessTokenDecorator(http: retryDecorator, tokenAdapter: tokenAdapter)
        tokenDecorator?.get(from: URLS.env.identityStore, method: .POST, headers: headers, body: data, completion: { result in
            switch result {
            case let .success(data, response):
                completion(IdentityStoreModelMapper.map(from: data, from: response))
                
            case .failure:
                completion(.failure(.connectivity))
            }
        })
    }
}

private struct IdentityStoreModelMapper {
    
    private static var OK_200: Int { 200 }
    private static var failed_401: Int { 401 }
    private static var serverError_500: Int { 500 }
    
    static func map(from data: Data, from response: HTTPURLResponse) -> RemoteIdentityStoreLoader.Result {
        
        guard response.statusCode == OK_200,
            let model = try? JSONDecoder().decode(IdentityStoreModel.self, from: data) else {
                if response.statusCode == failed_401 {
                    return .failure(RemoteIdentityStoreLoader.Error.authFailed)
                } else if response.statusCode == serverError_500 {
                    return .failure(RemoteIdentityStoreLoader.Error.serverError)
                } else {
                    return .failure(RemoteIdentityStoreLoader.Error.invalidData)
                }
        }
        
        return .success(model)
    }
}

extension Encodable {
    var data: Data? {
        return try? JSONEncoder().encode(self)
    }
}

public extension URLRequest {
    mutating func httpMethod(_ method: HTTPMethod) {
        self.httpMethod = method.rawValue
    }
}
