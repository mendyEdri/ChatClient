//
//  AccessTokenRemoteAdapter.swift
//  TDDChatProject
//
//  Created by Mendy Edri on 14/01/2020.
//  Copyright © 2020 CWT. All rights reserved.
//

import Foundation
import lit_networking


final class AccessTokenMockAdapter: AccessTokenAdapter {
    func requestAccessToken(_ completion: @escaping (Result<String, Error>) -> Void) {
        completion(.success("eyJhbGciOiJIUzI1NiIsImtpZCI6InRva2VuQ2VydCJ9.eyJzY29wZSI6WyJvcGVuaWQiLCJwcm9maWxlIl0sImNsaWVudF9pZCI6IkN3dFRvR29PYXV0aENsaWVudCIsImp3dE9BdXRoIjoiZjQwb0E0NjB5S2JYdVJMdnZGdVA5NUhYcGt2MVNtRzgiLCJpZG1FbWFpbCI6ImRlQHlvcG1haWwuY29tIiwibGFzdE5hbWUiOiJJRE0iLCJ0b3BJZCI6IjE0OjRhYjczIiwicm9sZXMiOiJ0cmF2ZWxlciIsInRyYXZlbGVyRW1haWwiOiJkZUB5b3BtYWlsLmNvbSIsInRyYXZlbGVyVHlwZUdVSUQiOiIxNDo0MWMzNSIsInN1YklkIjoiMTQ6YzU0NTAiLCJmaXJzdE5hbWUiOiJERSIsIm1pZGRsZU5hbWUiOiJ0ZWFzdCIsImlkIjoiNzc3YWUwOGItNmE2Yi00MmU5LTkwNjgtMzE0ZGUwNGJjOTgyIiwidHJhdmVsZXJHVUlEIjoiMTQ6MjU5Nzc5OGUiLCJ1c2VybmFtZSI6ImRlQHlvcG1haWwuY29tIiwiZXhwIjoxOTgwMzA0NDQ4fQ.CEZL9DL_dc9kcu8ZF7ZdciOroneqhC6tyB-ymPOWWW8"))
    }
}
