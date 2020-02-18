//
//  URLS.swift
//  ChatProject
//
//  Created by Mendy Edri on 05/02/2020.
//  Copyright © 2020 CWT. All rights reserved.
//

import Foundation

enum URLS {
    case production
    case stage
    
    static var env: URLS {
        switch Configuration.env {
        case .production:
            return .production
        case .stage:
            return .stage
        }
    }
    
    var accountsBase: String {
        switch self {
        case .production:
            return "https://accounts.mycwt.com"
        case .stage:
            return "https://accounts.stage-mycwt.com"
        }
    }
    
    var apiBase: String {
        switch self {
        case .production:
            return "https://api.worldmate.com"
        case .stage:
            return "https://apistage.worldmate.com"
        }
    }
}
