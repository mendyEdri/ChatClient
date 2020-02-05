//
//  AccessTokenPingAdapter.swift
//  TDDChatProject
//
//  Created by Mendy Edri on 29/01/2020.
//  Copyright © 2020 CWT. All rights reserved.
//

import Foundation
import lit_networking

final class AccessTokenPingAdapter: AccessTokenAdapter {
    
    func requestAccessToken(_ completion: @escaping (Result<String, Error>) -> Void) {
        #warning("Replace it with a real implementation")
        
        #if !DEBUG
            fatalError("This should not be called, until real implementation")
        #else
        completion(.success("eyJhbGciOiJSUzUxMiIsImtpZCI6InRva2VuQ2VydCJ9.eyJzY29wZSI6WyJvcGVuaWQiLCJwcm9maWxlIl0sImNsaWVudF9pZCI6IkN3dFRvR29PYXV0aENsaWVudCIsImp3dE9BdXRoIjoidWtsa3lLeFJrdGhRSkF3cHNtVGNocjhmSmM4NlFKQjUiLCJpZG1FbWFpbCI6ImRlQHlvcG1haWwuY29tIiwibGFzdE5hbWUiOiJJRE0iLCJ0b3BJZCI6IjE0OjRhYjczIiwicm9sZXMiOiJ0cmF2ZWxlciIsInRyYXZlbGVyRW1haWwiOiJkZUB5b3BtYWlsLmNvbSIsInRyYXZlbGVyVHlwZUdVSUQiOiIxNDo0MWMzNSIsInN1YklkIjoiMTQ6YzU0NTAiLCJmaXJzdE5hbWUiOiJERSIsIm1pZGRsZU5hbWUiOiJ0ZWFzdCIsImlkIjoiNzc3YWUwOGItNmE2Yi00MmU5LTkwNjgtMzE0ZGUwNGJjOTgyIiwidHJhdmVsZXJHVUlEIjoiMTQ6MjU5Nzc5OGUiLCJ1c2VybmFtZSI6ImRlQHlvcG1haWwuY29tIiwiZXhwIjoxNTgwODIxODUwfQ.Uhykn6lAsKk7B5EGFz6oa53S5IefddG_IhfkeGoHV011-uCQ8sSTtpCNpCVXhti8WhrjO4or_BemrzSr3MBBDHp11AdfV-NGtUV9RtWyR59qess5-eOqIVYBInhxwRD2bV1uUJLLWLHi48A6xLNzHJr38FW1bqp0juCojzDZBbjjWxmdcDqGSyLNLrTk3MmlbiAKfV6WfsyPeWNsTzpgAAmmvlhz7OzjDqq8kq1vbfXZfG73gD8axuF9ifDGqhRHMAGrWh2-_mysxP-waOj6IbvY0NPYG1OaPBEbxw93IcaBAlBcPWrRS4WLVHcTxy1osHH6zLjhaYrYcvQ-htG8sA"))
        #endif
    }
}
