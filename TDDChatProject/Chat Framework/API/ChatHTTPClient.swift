//
//  ChatHTTPClient.swift
//  ChatHTTPLoader
//
//  Created by Mendy Edri on 30/10/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import Foundation

/** All supported http request methods */
public enum HTTPMethod: String {
    case GET
    case POST
    case DELETE
    case UPDATE
}

/** Protocol for chat requests - STS, STS-metadata, Identity-Store */
public protocol ChatHTTPClient {
    
    /** HTTP response enum type, represents ChatHTTPClient requests' response object */
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    /** Generic request from URL function, used in Chat module  */
    func get(from url: URL, method: HTTPMethod, completion: @escaping (Result) -> Void)
}
