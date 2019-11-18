//
//  ChatHTTPClient.swift
//  ChatHTTPLoader
//
//  Created by Mendy Edri on 30/10/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import Foundation

/** HTTP response enum type, represents ChatHTTPClient requests' response object */
public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

/** Protocol for chat requests - STS, STS-metadata, Identity-Store */
public protocol ChatHTTPClient {
    /** Generic request from URL function, used in Chat module  */
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
