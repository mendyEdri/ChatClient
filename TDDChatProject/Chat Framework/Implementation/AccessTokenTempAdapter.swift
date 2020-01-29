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
        completion(.success("eyJhbGciOiJSUzUxMiIsImtpZCI6InRva2VuQ2VydCJ9.eyJzY29wZSI6WyJvcGVuaWQiLCJwcm9maWxlIl0sImNsaWVudF9pZCI6IkN3dFRvR29PYXV0aENsaWVudCIsImp3dE9BdXRoIjoiVlplS0NmZDZnaGU3d2tkbnhYSFJDSkZyU1FmUENtMHgiLCJpZG1FbWFpbCI6ImRlQHlvcG1haWwuY29tIiwibGFzdE5hbWUiOiJJRE0iLCJ0b3BJZCI6IjE0OjRhYjczIiwicm9sZXMiOiJ0cmF2ZWxlciIsInRyYXZlbGVyRW1haWwiOiJkZUB5b3BtYWlsLmNvbSIsInRyYXZlbGVyVHlwZUdVSUQiOiIxNDo0MWMzNSIsInN1YklkIjoiMTQ6YzU0NTAiLCJmaXJzdE5hbWUiOiJERSIsIm1pZGRsZU5hbWUiOiJ0ZWFzdCIsImlkIjoiNzc3YWUwOGItNmE2Yi00MmU5LTkwNjgtMzE0ZGUwNGJjOTgyIiwidHJhdmVsZXJHVUlEIjoiMTQ6MjU5Nzc5OGUiLCJ1c2VybmFtZSI6ImRlQHlvcG1haWwuY29tIiwiZXhwIjoxNTgwMjk5MDc5fQ.VBvQyUS3vFpiMABWQlNpIzaw4fVhvOC3O2ErvASOnkoLxidSpHEap4isy-NqUlS8SsEXTvwGMwme1zj6s1l-7pHcN89C_2T3v7cOQLvE2AJbsTX9Wg6MOmqtJv29rvgz-CIB1c0IoGM9XXFuf-fB2oWGwcoVrhqwKa_aMBBCqpdlE-KknOPK29HnC6_QWRVnkp_TlYudBRg2mY1t-ls94knAxRpIFrmrAoWWBMNMYlO8BULTiLXf5tCAz6lS8wIoac2HdZWN92Rq4xCwaLkfc9JJeYfS0zgWt9omP3sqhyZqpHWFe1DMxgshbwPsfWIRErfcMBw5AdEpadpILnAUoA"))
    }
}
