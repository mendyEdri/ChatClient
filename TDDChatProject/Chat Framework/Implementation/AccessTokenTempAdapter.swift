//
//  AccessTokenRemoteAdapter.swift
//  TDDChatProject
//
//  Created by Mendy Edri on 14/01/2020.
//  Copyright © 2020 CWT. All rights reserved.
//

import Foundation
import lit_networking

class AccessTokenRemoteAdapter: AccessTokenAdapter {
    
    func requestAccessToken(_ completion: @escaping (Result<String, Error>) -> Void) {
        let loader = RemoteAccessTokenLoader(url: URL(string: "https://accounts.mycwt.com/as/token.oauth2")!, client: URLSessionHTTPClient())
        
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

class AccessTokenMockAdapter: AccessTokenAdapter {
    func requestAccessToken(_ completion: @escaping (Result<String, Error>) -> Void) {
        completion(.success("eyJhbGciOiJSUzUxMiIsImtpZCI6InRva2VuQ2VydCJ9.eyJzY29wZSI6WyJvcGVuaWQiLCJwcm9maWxlIl0sImNsaWVudF9pZCI6IkN3dFRvR29PYXV0aENsaWVudCIsImp3dE9BdXRoIjoiVFNIbUV3YzNpcVhLVTh6YU5KZFBZNTlDY2J0MnJtSFIiLCJpZG1FbWFpbCI6ImRlQHlvcG1haWwuY29tIiwibGFzdE5hbWUiOiJJRE0iLCJ0b3BJZCI6IjE0OjRhYjczIiwicm9sZXMiOiJ0cmF2ZWxlciIsInRyYXZlbGVyRW1haWwiOiJkZUB5b3BtYWlsLmNvbSIsInRyYXZlbGVyVHlwZUdVSUQiOiIxNDo0MWMzNSIsInN1YklkIjoiMTQ6YzU0NTAiLCJmaXJzdE5hbWUiOiJERSIsIm1pZGRsZU5hbWUiOiJ0ZWFzdCIsImlkIjoiNzc3YWUwOGItNmE2Yi00MmU5LTkwNjgtMzE0ZGUwNGJjOTgyIiwidHJhdmVsZXJHVUlEIjoiMTQ6MjU5Nzc5OGUiLCJ1c2VybmFtZSI6ImRlQHlvcG1haWwuY29tIiwiZXhwIjoxNTc5ODE0NDg3fQ.ha_cvUu9cMXEAFV1kJGspuDzGiQ342-IMb1DipANMXLtgvLWJ9hOl3VjF8Di5Bl3RZ4QwTqdYngf8LKtEgCNWW6zFRmx5BJGVthDZ5ydnNZaEX47DpvLmzMw2n7RjbfgH0loDwgM6Di2JseJaIdXPjzXuXTUsZB7h6rHAsthmRKsoBuQ4IUKVnJ9vNErDNuQsT6Q_4QFfyXP9JIwcbBffUtHykaNzlIASODWgy3vuWKjOVk5nnmw5n8IA5-PdSL6fveAN6nWB82lhuB5l2-ikVe-FI8pz713C9WRnAmMm-Cpks-sPVUS__ehA_KOStxj_m8VtD6c8Hn38YjWPE8GSg"))
    }
}
