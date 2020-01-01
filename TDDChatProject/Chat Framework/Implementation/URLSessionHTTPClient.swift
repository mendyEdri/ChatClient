//
//  URLSessionHTTPClient.swift
//  TDDChatProject
//
//  Created by Mendy Edri on 09/12/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import Foundation

/** Implementation of ChatHTTPClient, fires requsts with NSURLSession */

public class URLSessionHTTPClient: HTTPClient {
  
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    struct UnexpectedValueRepresentation: Error {}
    
    public func get(from url: URL, method: HTTPMethod, headers:  [String: String]? = nil, body: [String: String]? = nil, completion: @escaping (HTTPClient.Result) -> Void) {
        let request = URLRequest(url: url, method: method, headers: headers, body: body)
        run(request: request, completion)
    }
    
    private func run(request: URLRequest, _ completion: @escaping (HTTPClient.Result) -> Void) {
        let callerThread = OperationQueue.current
        session.dataTask(with: request) { [weak callerThread] data, response, error in
            debugPrint("Request Ended")
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

private extension URLRequest {
    
    init(url: URL, method: HTTPMethod, headers: [String: String]?, body: [String: String]?) {
        self.init(url: url)
        httpMethod = method.rawValue
        
        httpBody = body?.asString(joined: "&").data(using: .utf8)
        allHTTPHeaderFields = headers
    }
}

private extension Dictionary {
    func asString(joined symbol: String) -> String {
        return (compactMap { "\($0)=\($1)" } as Array).joined(separator: symbol)
    }
}
