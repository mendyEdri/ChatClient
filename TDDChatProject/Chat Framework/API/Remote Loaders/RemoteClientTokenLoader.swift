//
//  RemoteChatTokenLoader.swift
//  ChatHTTPLoader
//
//  Created by Mendy Edri on 03/11/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import Foundation
import lit_networking

/** STS - request, Loads token uses to login into chat vendor sdk */

public class RemoteClientTokenLoader {
    
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
        case authFailed
        case unknownVendor
    }
    
    public typealias Result = Swift.Result<ChatVendorToken, Error>
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load(completion: @escaping (Result) -> Void) {
        let decoratedAccessToken = HTTPClientAccessTokenDecorator(http: client, tokenAdapter: AccessTokenTempAdapter())
        decoratedAccessToken.get(from: url, method: .POST, headers: Headers.pairs()) { result in
            switch result {
            case let .success(data, response):
                completion(ChatVendorTokenMapper.map(data: data, from: response))
                
            case .failure:
                completion(.failure(.authFailed))
            }
        }
    }
}

extension RemoteClientTokenLoader {
    
    private enum Headers: String {
        case tokenType = "cwt-token-type"
        case clientId = "cwt-client-id"
        
        private func key() -> String {
            return self.rawValue
        }
        
        private func value() -> String {
            switch self {
            case .tokenType:
                return "pingFed"
                
            case .clientId:
                return "CwtToGoOauthClient"
            }
        }
        
        static func pairs() -> [String: String] {
            var pairs = [String: String]()
            
            pairs[Headers.tokenType.key()] = Headers.tokenType.value()
            pairs[Headers.clientId.key()] = Headers.clientId.value()
            
            return pairs
        }
    }
}

internal struct ChatVendorTokenMapper {
    private static var OK_200: Int { 200 }
    private static var AUTH_FAILED_401: Int { 401 }
    private static var UNKNOWN_VENDOR_404: Int { 404 }
    
    internal static func map(data: Data, from response: HTTPURLResponse) -> RemoteClientTokenLoader.Result {
        guard response.statusCode == OK_200,
            let chatToken = try? JSONDecoder().decode(ChatVendorToken.self, from: data) else { 
                switch response.statusCode {
                case AUTH_FAILED_401:
                    return .failure(.authFailed)
                case UNKNOWN_VENDOR_404:
                    return .failure(.unknownVendor)
                default:
                    return .failure(.invalidData)
                }
        }
        return .success(chatToken)
    }
}

