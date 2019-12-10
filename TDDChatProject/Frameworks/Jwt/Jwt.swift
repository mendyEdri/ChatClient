//
//  Jwt.swift
//  Jwt
//
//  Created by Mendy Edri on 29/10/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import Foundation

/** Modular Jwt, suitable for myCWT needs */

protocol Jwtable {
    func isJwtExp() throws -> Bool
    var jwtString: String { get set }
    var parser: JwtParserable { get }
    func value(for key: String) -> String?
}

struct Jwt: Jwtable {
    
    enum Error: Swift.Error {
        case invalid
    }
        
    var jwtString: String {
        didSet {
            parser.jwt(self.jwtString)
        }
    }
    
    var parser: JwtParserable
    
    init() {
        parser = JwtDefaultParser(jwt: "")
        self = Jwt(string: "", parser: parser)
    }
    
    init(string: String, parser: JwtParserable) {
        self.jwtString = string
        
        self.parser = parser
        self.parser.jwt(jwtString)
    }
    
    func value(for key: String) -> String? {
        return parser.value(for: key) as? String
    }
    
    // MARK: Jwtable Implementation
    
    func isJwtExp() throws -> Bool {
        guard let experation = parser.value(for: CommonKeys.experation.rawValue) as? Double else {
            throw Error.invalid
        }
        let now = Date().timeIntervalSince1970
        return experation <= now
    }
}

extension Jwt {
    private enum CommonKeys: String {
        case experation = "exp"
        case userId = "userId"
        case pingId = "id"
    }
}
