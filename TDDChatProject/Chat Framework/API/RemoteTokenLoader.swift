//
//  RemoteChatTokenLoader.swift
//  ChatHTTPLoader
//
//  Created by Mendy Edri on 03/11/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import Foundation

/** STS - request, Loads token uses to login into chat vendor sdk */

public class RemoteTokenLoader {
    private let url: URL
    private let client: ChatHTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
        case authFailed
        case unknownVendor
    }
    
    public typealias Result = Swift.Result<ChatVendorToken, Error>
    
    public init(url: URL, client: ChatHTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load(completion: @escaping (Result) -> Void) {
        client.get(from: url, method: .POST) { result in
            switch result {
            case let .success(data, response):
                completion(ChatVendorTokenMapper.map(data: data, from: response))
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}

internal struct ChatVendorTokenMapper {
    private static var OK_200: Int { 200 }
    private static var AUTH_FAILED_401: Int { 401 }
    private static var UNKNOWN_VENDOR_404: Int { 404 }
    
    internal static func map(data: Data, from response: HTTPURLResponse) -> RemoteTokenLoader.Result {
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

