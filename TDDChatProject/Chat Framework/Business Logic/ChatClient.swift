//
//  Chatable.swift
//  ChatHTTPLoader
//
//  Created by Mendy Edri on 06/11/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import Foundation

/** Protocol for Initialization. To make Intializable decupled from ChatClient  */
public protocol Initializable {
    typealias StartResult = Result<String, ClientManager.Error>
    
    func startSDK(_ appId: String, completion: @escaping (StartResult) -> Void)
}

/** Protocol for Login to a SDK. seperated from ChatClient to have more flexability for other SDK that might not need Initializable protocol */
public protocol Loginable {
    typealias LoginResult = Result<String, ClientManager.Error>
    
    func initialized() -> Bool
    func loggedIn() -> Bool
    func login(userId: String, token: String, completion: @escaping (LoginResult) -> Void)
    func logout(completion: @escaping (LoginResult) -> Void)
}

/** Chat Client Protocol, conforms to Initializable and Loginable */
public protocol ChatClient: Initializable, Loginable {
    var appIdKey: String { get }
    var userTokenKey: String { get }
}

extension ChatClient {
    public var appIdKey: String {
        return "\(type(of: self)).appIdKey"
    }
    
    public var userTokenKey: String {
        return "\(type(of: self)).userTokenKey"
    }
}
