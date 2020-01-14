//
//  RemoteAccessTokenLoader.swift
//  TDDChatProject
//
//  Created by Mendy Edri on 23/12/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import Foundation
import lit_networking

public struct AccessToken: Codable {
    var accessToken: String
    var refreshToken: String
    var type: String
    var expiration: TimeInterval
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case type = "token_type"
        case expiration = "expires_in"
    }
}

public enum AccessTokenLoaderURL: String {
    case stage = "https://test.mytravel.carlsonwagonlit.com/as/token.oauth2"
    case prod = "https://accounts.mycwt.com/as/token.oauth2"
    
    public var url: URL {
        return URL(string: self.rawValue)!
    }
}

public class RemoteAccessTokenLoader {
    
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
        case authFailed
        case unknownVendor
    }
    
    public typealias Result = Swift.Result<AccessToken, Error>
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url, method: .POST, headers: Pairs.oauthHeaders, body: Pairs.oauthBody) { result in
            switch result {
            case let .success(data, response):
                completion(RemoteAccessTokenMapper.map(data: data, from: response))
                
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}

struct RemoteAccessTokenMapper {
    
    private static var OK_200: Int { 200 }
    
    private static var BAD_400: Int { 400 }
    
    internal static func map(data: Data, from response: HTTPURLResponse) -> RemoteAccessTokenLoader.Result {
        guard response.statusCode == OK_200,
        let accessToken = try? JSONDecoder().decode(AccessToken.self, from: data) else {
            return .failure(.invalidData)
        }
        return .success(accessToken)
    }
}

private extension RemoteAccessTokenLoader {
        
    enum Pairs: String {
        case clientId = "client_id"
        case grantType = "grant_type"
        case username = "username"
        case password = "password"
        case scope = "scope"
        
        case accept = "Accept"
        case contentType = "Content-Type"
        
        func key() -> String {
            return self.rawValue
        }
        
        func value() -> String {
            switch self {
            case .clientId:
                return "CwtToGoOauthClient"
            case .grantType:
                return "password"
            case .username:
                return "de@yopmail.com"
            case .password:
                return "qwerty10"
            case .scope:
                return "openid profile"
            case .accept:
                return "application/json"
            case .contentType:
                return "application/x-www-form-urlencoded"
            }
        }
        
        static func mappedBody() -> [String: String] {
            var pairs = [String: String]()
            
            pairs[Pairs.clientId.key()] = Pairs.clientId.value()
            pairs[Pairs.grantType.key()] = Pairs.grantType.value()
            pairs[Pairs.username.key()] = Pairs.username.value()
            pairs[Pairs.password.key()] = Pairs.password.value()
            pairs[Pairs.scope.key()] = Pairs.scope.value()
            
            return pairs
        }
        
        static func mappedHeaders() -> [String: String] {
            var pairs = [String: String]()
            
            pairs[Pairs.accept.key()] = Pairs.accept.value()
            pairs[Pairs.contentType.key()] = Pairs.contentType.value()
            return pairs
        }
        
        static var oauthBody: [String: String] {
            Pairs.mappedBody()
        }
        
        static var oauthHeaders: [String: String] {
            return Pairs.mappedHeaders()
        }
    }
}
