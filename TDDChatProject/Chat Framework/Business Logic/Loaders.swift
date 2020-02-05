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
    
    init(client: HTTPClient, storage: Storage) {
        appId = RemoteAppIdLoader(url: URLS.env.smoochVendorAppId, client: client)
        userToken = RemoteClientTokenLoader(url: URLS.env.smoochVendorToken, client: client)
        identityStore = IdentityStoreController(url: URLS.env.identityStore, httpClient: client, storage: storage)
    }
}
