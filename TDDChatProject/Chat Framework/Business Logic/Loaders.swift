//
//  Loaders.swift
//  TDDChatProject
//
//  Created by Mendy Edri on 15/01/2020.
//  Copyright © 2020 CWT. All rights reserved.
//

import Foundation
import lit_networking

internal struct Loaders {
    var appId: RemoteAppIdLoader
    var userToken: RemoteClientTokenLoader
    var identityStore: IdentityStoreController
    
    private let appIdEndpointURL = URL(string: "https://api.worldmate.com/tokens/vendors/smooch/metadata")!
    private let userTokenEndpointURL = URL(string: "https://api.worldmate.com/tokens/vendors/smooch")!
    private let identityStoreURL = URL(string: "https://api.worldmate.com/identity-store/api/v1/register")!
    
    init(client: HTTPClient, storage: Storage) {
        appId = RemoteAppIdLoader(url: appIdEndpointURL, client: client)
        userToken = RemoteClientTokenLoader(url: userTokenEndpointURL, client: client)
        identityStore = IdentityStoreController(url: identityStoreURL, httpClient: client, storage: storage)
    }
}
