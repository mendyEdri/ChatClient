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
        completion(.success("eyJhbGciOiJSUzUxMiIsImtpZCI6InRva2VuQ2VydCJ9.eyJzY29wZSI6WyJvcGVuaWQiLCJwcm9maWxlIl0sImNsaWVudF9pZCI6IkN3dFRvR29PYXV0aENsaWVudCIsImp3dE9BdXRoIjoieWxKTmlmcFB6d2dBRGZsTEs5dTBUVkNPTHNxa1IybWUiLCJpZG1FbWFpbCI6ImRlQHlvcG1haWwuY29tIiwibGFzdE5hbWUiOiJJRE0iLCJ0b3BJZCI6IjE0OjRhYjczIiwicm9sZXMiOiJ0cmF2ZWxlciIsInRyYXZlbGVyRW1haWwiOiJkZUB5b3BtYWlsLmNvbSIsInRyYXZlbGVyVHlwZUdVSUQiOiIxNDo0MWMzNSIsInN1YklkIjoiMTQ6YzU0NTAiLCJmaXJzdE5hbWUiOiJERSIsIm1pZGRsZU5hbWUiOiJ0ZWFzdCIsImlkIjoiNzc3YWUwOGItNmE2Yi00MmU5LTkwNjgtMzE0ZGUwNGJjOTgyIiwidHJhdmVsZXJHVUlEIjoiMTQ6MjU5Nzc5OGUiLCJ1c2VybmFtZSI6ImRlQHlvcG1haWwuY29tIiwiZXhwIjoxNTc5NzAxMjg1fQ.c0btpa5mh3XA1b8GwO2LIelYZA35RO9bhA8qf684ZsvLxg-AJTt9ijsWg1SUZzdjwVozrRNJIi4DtjSiCEpsBmEzZ4aP1iLKrvwfhGdnMKmbeaHKFNpOZyl5rCNKec9gaCPajVrm60q_3VHztSwHLeQ3q38zY9_8HrKltIDCqyDg4EERCr02WLUfftW8xEX-lodOY6PbROIdJe-U23Yuw2I7By3U1qsIqfOaQnxrsvM_tcecvJOi8nYzbeIKX3_Er_SRI_husK2ogTagp6iax4-6MnmIfQYF-nxMViMWTWd7UOFDAO-F1x5ISD0qKKVNIqHj--c4OewDbQeU7oUylA"))
    }
}
