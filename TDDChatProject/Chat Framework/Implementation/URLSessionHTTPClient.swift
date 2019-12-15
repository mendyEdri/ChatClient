//
//  URLSessionHTTPClient.swift
//  TDDChatProject
//
//  Created by Mendy Edri on 09/12/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import Foundation

/** Implementation */

public class URLSessionHTTPClient: ChatHTTPClient {
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    struct UnexpectedValueRepresentation: Error {}
    
    public func get(from url: URL, method: HTTPMethod = .GET, completion: @escaping (ChatHTTPClient.Result) -> Void) {
    
        let request = URLRequest(url: url, method: method, tempHeaders: true)
        run(request: request, completion)
    }
    
    private func run(request: URLRequest, _ completion: @escaping (ChatHTTPClient.Result) -> Void) {
        let callerThread = OperationQueue.current
        session.dataTask(with: request) { data, response, error in
            callerThread?.addOperation {
                completion(Result {
                    if let error = error {
                        throw error
                    } else if let data = data, let response = response as? HTTPURLResponse {
                        return (data, response)
                    } else {
                        throw UnexpectedValueRepresentation()
                    }
                })
            }
        }.resume()
    }
}

#warning("Temp Implementation, remove after integratoin with myCWT app")

private extension URLRequest {
    
    init(url: URL, method: HTTPMethod, tempHeaders: Bool) {
        self.init(url: url)
        httpMethod = method.rawValue
        URLRequest.appendTempHeaders(to: &self)
    }
    
    static func appendTempHeaders(to request: inout URLRequest) {
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("pingFed", forHTTPHeaderField: "cwt-token-type")
        request.addValue("CwtToGoOauthClient", forHTTPHeaderField: "cwt-client-id")
        request.addValue(URLRequest.replaceableToken, forHTTPHeaderField: "Authorization")
    }
    
    private static var replaceableToken: String {
        return "Bearer " + "eyJhbGciOiJSUzUxMiIsImtpZCI6InRva2VuQ2VydCJ9.eyJzY29wZSI6WyJvcGVuaWQiLCJwcm9maWxlIl0sImNsaWVudF9pZCI6IkN3dFRvR29PYXV0aENsaWVudCIsImp3dE9BdXRoIjoiTWJkcWtwZFdYQnd0cHp5ZjRZcUFtam1hdmhkU25HYW8iLCJpZG1FbWFpbCI6ImRlQHlvcG1haWwuY29tIiwibGFzdE5hbWUiOiJJRE0iLCJ0b3BJZCI6IjE0OjRhYjczIiwicm9sZXMiOiJ0cmF2ZWxlciIsInRyYXZlbGVyRW1haWwiOiJkZUB5b3BtYWlsLmNvbSIsInRyYXZlbGVyVHlwZUdVSUQiOiIxNDo0MWMzNSIsInN1YklkIjoiMTQ6YzU0NTAiLCJmaXJzdE5hbWUiOiJERSIsIm1pZGRsZU5hbWUiOiJ0ZWFzdCIsImlkIjoiNzc3YWUwOGItNmE2Yi00MmU5LTkwNjgtMzE0ZGUwNGJjOTgyIiwidHJhdmVsZXJHVUlEIjoiMTQ6MjU5Nzc5OGUiLCJ1c2VybmFtZSI6ImRlQHlvcG1haWwuY29tIiwiZXhwIjoxNTc2NDEzODgzfQ.cRPcvIo7A1QBPmEvT3bMJ7nydpnP0R0StPnIezISnvgXRt_xtHn5oxzl4_j5FvFJ0tYmGHL5DBR6ujd0KOn3qcZQkAi9r3NdmklZBtNhaKIxNCxdHof96F-6CTG9O71c1UXfmqnI72AYyru6XHIMh8oRH-3e5bEjx3ebD4lysO-MbR6WWchQo_BsbSI_W_KueK5OSoV9O_He2OOJwUM8D43Ojcf9fODxnSVfkEJlg7I8wRjRsshx1ckF_4ei2a5NostR0SdtVPMYZuF-3RssronzttA_Txq9zYgTQRWSD3aMMO-3JF0TCnR61PqQFDaQuH_Cg3UiPEoKpur9Gks5WA"
    }
}
