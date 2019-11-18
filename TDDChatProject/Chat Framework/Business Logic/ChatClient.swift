//
//  Chatable.swift
//  ChatHTTPLoader
//
//  Created by Mendy Edri on 06/11/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import Foundation

/** Enum type returns success or failure with an associated value */
public struct ChatSettings {
    var appId: String
    var userId: String
    var token: String
}

/** Protocol for Initialization. To make Intializable decupled from ChatClient ChatSettings property */
public protocol Initializable {
    typealias StartResult = Result<String, ClientManager.Error>
    
    func startSDK(_ appId: String, completion: @escaping (StartResult) -> Void)
}

/** Protocol for Login to a SDK. seperated from ChatClient to have more flexability for other SDK that might not need Initializable protocol */
public protocol Loginable {
    typealias LoginResult = Result<String, ClientManager.Error>
    
    func canLogin() -> Bool
    func login(userId: String, token: String, completion: @escaping (LoginResult) -> Void)
    func logout(completion: @escaping (LoginResult) -> Void)
}

/** Chat Client Protocol, conforms to Initializable and Loginable, on his own added ChatSettings */
public protocol ChatClient: Initializable, Loginable {
    /** Enum type returns success or failure with an associated value */
    var settings: ChatSettings { get }
}
