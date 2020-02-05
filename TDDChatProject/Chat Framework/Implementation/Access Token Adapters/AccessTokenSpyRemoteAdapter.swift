//
//  AccessTokenSpyRemoteAdapter.swift
//  TDDChatProject
//
//  Created by Mendy Edri on 29/01/2020.
//  Copyright © 2020 CWT. All rights reserved.
//

import Foundation
import lit_networking

final class AccessTokenSpyRemoteAdapter: AccessTokenAdapter {
    
    func requestAccessToken(_ completion: @escaping (Result<String, Error>) -> Void) {
        let loader = RemoteAccessTokenSpyLoader(url: URL(string: "https://accounts.mycwt.com/as/token.oauth2")!, client: URLSessionHTTPClient())
        
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
