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
            fatalError("This should not be called, it should be implemented")
        #else
        if Configuration.env == .stage {
            completion(.success("eyJhbGciOiJSUzUxMiIsImtpZCI6InRva2VuQ2VydCJ9.eyJzY29wZSI6WyJvcGVuaWQiLCJwcm9maWxlIl0sImNsaWVudF9pZCI6IkN3dFRvR29PYXV0aENsaWVudCIsImp3dE9BdXRoIjoiTEQyaEVpM3V6dk1zMXJVbW9NUGRHbm15bXZqSld6cVkiLCJpZG1FbWFpbCI6ImRlQHlvcG1haWwuY29tIiwibGFzdE5hbWUiOiJJRE0iLCJ0b3BJZCI6IkE6NUEyQTUiLCJyb2xlcyI6WyJ0cmF2ZWxlciIsImFycmFuZ2VyIl0sInRyYXZlbGVyRW1haWwiOiJkZUB5b3BtYWlsLmNvbSIsInRyYXZlbGVyVHlwZUdVSUQiOiJBOjQwNEVBIiwic3ViSWQiOiJBOjVBMkI2IiwiZmlyc3ROYW1lIjoiREUiLCJpZCI6Ijg3ZTRmNTNkLWEyODQtNDg5YS1iZmZkLWUxNWY0MjgyZDkwYSIsIjNyZFBhcnR5U3luY0lkIjoiVEE2MzlOWkxOSyIsInRyYXZlbGVyR1VJRCI6IkE6NDA0RkQ2MDgiLCJ1c2VybmFtZSI6ImRlQHlvcG1haWwuY29tIiwiZXhwIjoxNTgxOTQ3MTc5fQ.p87IPeUhpMN7h7YBoghee_OLzE0UQJi2ms0TEpkWzI6KJhwDjUlf8p68ZfKJKEVT5y6F_s4USWDzpiBAzdUlWBD7gSxCjixN-NxOwaSI4WrPigUik3lX83fy76GbmT5d3_j5gfEU8RcMRlbVkQH2KsnbtJaoBCHnHHgo_LBwfD9Qr8aqdSUi2bcuRc3yoowxwe3o6YO4x3BTkp7hrdOX8Q9r6xFn8JfkqkgrednCcUxEuUQCOyH8Sw-bWXmj5_Ezi6VBPe6bdpaP69VC44tVcjO6dtvzuN3j2BPpFKasvsGXljqxZR_RmUC5hcSURDW8gE4yiWg2wY9beqGw1_gr9Q"))
        } else {
            completion(.success("eyJhbGciOiJSUzUxMiIsImtpZCI6InRva2VuQ2VydCJ9.eyJzY29wZSI6WyJvcGVuaWQiLCJwcm9maWxlIl0sImNsaWVudF9pZCI6IkN3dFRvR29PYXV0aENsaWVudCIsImp3dE9BdXRoIjoicU5zaXg3QndGTTZLa3FwMHhKVWdqR0VIWEkyS1N2TkkiLCJpZG1FbWFpbCI6ImRlQHlvcG1haWwuY29tIiwibGFzdE5hbWUiOiJJRE0iLCJ0b3BJZCI6IjE0OjRhYjczIiwicm9sZXMiOiJ0cmF2ZWxlciIsInRyYXZlbGVyRW1haWwiOiJkZUB5b3BtYWlsLmNvbSIsInRyYXZlbGVyVHlwZUdVSUQiOiIxNDo0MWMzNSIsInN1YklkIjoiMTQ6YzU0NTAiLCJmaXJzdE5hbWUiOiJERSIsIm1pZGRsZU5hbWUiOiJ0ZWFzdCIsImlkIjoiNzc3YWUwOGItNmE2Yi00MmU5LTkwNjgtMzE0ZGUwNGJjOTgyIiwidHJhdmVsZXJHVUlEIjoiMTQ6MjU5Nzc5OGUiLCJ1c2VybmFtZSI6ImRlQHlvcG1haWwuY29tIiwiZXhwIjoxNTgxOTQ3MTk0fQ.OGZ3Zc4S1cUMDOVFuv3GPJgqGqLxWW_mVo7c4nZttbrDzisTitgWSFEDKfD51NnmpjXK4RYfVP3Cyuiwu4WgtZF5q0ZtlGwSHof69uffaibLYf2p0cK8waiciW2_BFL7dmkocaSdnIsoikEUh8JlpR6R76MueqFZvEXe9OEJWaURrvEkW3MpW-A7eZodLvBtHRKsQDc8RKQT82o8rwdF5tZuHla8UtHOaE1N_JRX6llswmXNYFq1Vaf3wmRFGHw_cpS0FC_aS5RYXQhL5B1n_VuEivq12MEQtoiGccsNX5CgU2quV-S_etSqUuZh79rQd2xDbwHE1n_gJ0Pjk16A5Q"))
        }
        #endif
    }
}
