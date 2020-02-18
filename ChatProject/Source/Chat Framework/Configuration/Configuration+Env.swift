//
//  Configuration+Env.swift
//  ChatProject
//
//  Created by Mendy Edri on 05/02/2020.
//  Copyright © 2020 CWT. All rights reserved.
//

import Foundation

public enum ENV {
    case production
    case stage
}

final class Configuration {
    private init() {}
    
    static var env: ENV = .production
}
