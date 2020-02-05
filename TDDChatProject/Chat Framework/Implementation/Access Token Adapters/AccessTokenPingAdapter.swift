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
        if Configuration.env == .stage {
            completion(.success("eyJhbGciOiJSUzUxMiIsImtpZCI6InRva2VuQ2VydCJ9.eyJzY29wZSI6WyJvcGVuaWQiLCJwcm9maWxlIl0sImNsaWVudF9pZCI6IkN3dFRvR29PYXV0aENsaWVudCIsImp3dE9BdXRoIjoiMTI1OXMzWmdQRWNiYkpjTUg5VHdqSUYybmdJemRoMWgiLCJpZG1FbWFpbCI6ImF0dGlhczU1NUBtYWlsaW5hdG9yLmNvbSIsImxhc3ROYW1lIjoiRml2ZSIsInRvcElkIjoiYTo1YTJhNSIsInJvbGVzIjoidHJhdmVsZXIiLCJ0cmF2ZWxlckVtYWlsIjoiYXR0aWFzNTU1QG1haWxpbmF0b3IuY29tIiwidHJhdmVsZXJUeXBlR1VJRCI6IkE6NDA0RUEiLCJzdWJJZCI6ImE6NWEyYjYiLCJmaXJzdE5hbWUiOiJBdHRpYXMiLCJpZCI6IjBlYTJlMTZiLWI3NzMtNGQwNS1iMTAxLTFkYTY4MTU5ZTgyMCIsIjNyZFBhcnR5U3luY0lkIjoiVDMyMjZDUzlITiIsInRyYXZlbGVyR1VJRCI6ImE6NDAyMGRkODgiLCJ1c2VybmFtZSI6ImF0dGlhczU1NUBtYWlsaW5hdG9yLmNvbSIsImV4cCI6MTU4MDkwODQyMH0.1EXgj5SwUOW_WHRd0L48gASzdOfhVCxqqVoJKfI2Jnf9bJKv9IgR_gnWxTUhvwtC14MILcEYLMtjl4SmsenaqF_1cqsiukCvJP-WvA0r9LhE6yAl4Dw1J-ujh6vUQPVbE7D5AvN-9eYd1wuiC5pKHhxlosln1i2YULqN4zqOCWvcc4_nYgFMs2dRQWRSUhEFO_qANu72uqO4RevXx_2pQOEmH3A8Ro-y7Na2kcIBEpRIbnfo3JQHC4o1G9edx1ZDtQ_24jy--EA1wE1_7Gc16a2ybgIoOPaL3e7TJbtmgCfcaW_56rhbOTclqlE93KRG5pPNJxSVPK-3xmRjAxL7LA"))
        } else {
            completion(.success("eyJhbGciOiJSUzUxMiIsImtpZCI6InRva2VuQ2VydCJ9.eyJzY29wZSI6WyJvcGVuaWQiLCJwcm9maWxlIl0sImNsaWVudF9pZCI6IkN3dFRvR29PYXV0aENsaWVudCIsImp3dE9BdXRoIjoiWWRIam1kOFJQa0tDREFCWkZCdXhoNGpLMllxSjE3UnYiLCJpZG1FbWFpbCI6ImRlQHlvcG1haWwuY29tIiwibGFzdE5hbWUiOiJJRE0iLCJ0b3BJZCI6IjE0OjRhYjczIiwicm9sZXMiOiJ0cmF2ZWxlciIsInRyYXZlbGVyRW1haWwiOiJkZUB5b3BtYWlsLmNvbSIsInRyYXZlbGVyVHlwZUdVSUQiOiIxNDo0MWMzNSIsInN1YklkIjoiMTQ6YzU0NTAiLCJmaXJzdE5hbWUiOiJERSIsIm1pZGRsZU5hbWUiOiJ0ZWFzdCIsImlkIjoiNzc3YWUwOGItNmE2Yi00MmU5LTkwNjgtMzE0ZGUwNGJjOTgyIiwidHJhdmVsZXJHVUlEIjoiMTQ6MjU5Nzc5OGUiLCJ1c2VybmFtZSI6ImRlQHlvcG1haWwuY29tIiwiZXhwIjoxNTgwOTA2ODc0fQ.YOjiuxQVjxJjY3NdavCYogaCkf1xL27ESK2FoO4VQNLcI9M5agMZncy4EdaSf90WppBdrfBFz67mA59aCD8ZKZ-fEs3qXkVzUkOyAp6yHrqO9Z5XjkdEzD-r2A7r5n2WTk5hOhI5YfdZ75o0_ILfbkniDtDXAOKmjxqyOVgDnPurSIkDl8OABE6ptiKsDrg1QEVtQxPI-STag99VJwg1vE5MIcZ4AfZzmQs4pJv3xLn1LyPwo1BYjl1dGngLWRFUo9YbeNGPXK2i4mnoAEFS314stLNxALGa_HejUddN0pt1HCUECW4NEoEXTQSIN2GNSXSKNgiC0F0jQBTYGanZeA"))
        }
        #endif
    }
}
