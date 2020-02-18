//
//  JwtDefaultParser.swift
//  Jwt
//
//  Created by Mendy Edri on 29/10/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import Foundation

protocol JwtParserable {
    func keyValue() -> [String: Any]
    func value(for key: String) -> Any?
    func jwt(_ string: String)
}

public class JwtDefaultParser: JwtParserable {
    
    private var parser: CWTJwtParser = CWTJwtParser()
    var jwtString: String?
    
    public init() {  }
    
    init(jwt: String) {
        jwtString = jwt
    }
    
    // MARK: JWTParsable Implementation
    
    func jwt(_ string: String) {
        jwtString = string
    }
    
    func keyValue() -> [String : Any] {
        return parser.parseJWT(token: jwtString)
    }
    
    func value(for key: String) -> Any? {
        return keyValue()[key]
    }
}

class CWTJwtParser {
    func parseJWT(token:String?)->[String:Any]{
        var parsedToken: [String:Any] = [:]
        if(token != nil){
            parsedToken = self.decode(jwtToken: token!)
        }
        return parsedToken
    }
    
    private func decode(jwtToken jwt: String) -> [String: Any] {
        let segments = jwt.components(separatedBy: ".")
        if(segments.count != 3){
            return [:]
        }
        return decodeJWTPart(segments[1]) ?? [:]
    }
    
    private func base64UrlDecode(_ value: String) -> Data? {
        var base64 = value
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
        let requiredLength = 4 * ceil(length / 4.0)
        let paddingLength = requiredLength - length
        if paddingLength > 0 {
            let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
            base64 = base64 + padding
        }
        return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
    }
    
    private func decodeJWTPart(_ value: String) -> [String: Any]? {
        guard let bodyData = base64UrlDecode(value),
            let json = try? JSONSerialization.jsonObject(with: bodyData, options: []), let payload = json as? [String: Any] else {
                return nil
        }
        
        return payload
    }
}
