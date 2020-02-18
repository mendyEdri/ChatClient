//
//  AccessTokenSpyRemoteAdapter.swift
//  ChatProject
//
//  Created by Mendy Edri on 29/01/2020.
//  Copyright © 2020 CWT. All rights reserved.
//

import Foundation
import lit_networking

final class AccessTokenSpyRemoteAdapter: AccessTokenAdapter {
    
    func requestAccessToken(_ completion: @escaping (Result<String, Error>) -> Void) {
        let loader = RemoteAccessTokenSpyLoader(url: URLS.env.authEndpoint, client: URLSessionHTTPClient())
        
        loader.load { result in 
            switch result {
            case let .failure(error):
                completion(.failure(error))
            
            case let .success(token):
                completion(.success(token.accessToken))
            }
        }
    }
}
