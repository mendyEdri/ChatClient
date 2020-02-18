//
//  Loaders.swift
//  TDDChatProject
//
//  Created by Mendy Edri on 17/02/2020.
//  Copyright © 2020 CWT. All rights reserved.
//

import Foundation
import lit_networking

public struct Loaders {
    var appIdLoader: RemoteAppIdLoader
    var tokenLoader: RemoteClientTokenLoader
    var identityController: IdentityStoreController
    
    init(http: HTTPClient, storage: Storage, account: IdentityInfo) {
        self.appIdLoader = Loaders.buildAppIdLoader(http: http)
        self.tokenLoader = Loaders.buildTokenLoader(http: http)
        self.identityController = Loaders.buildIdentityController(http: http, storage: storage, accountInfo: account)
    }
    
    private static func buildAppIdLoader(http: HTTPClient) -> RemoteAppIdLoader {
        return RemoteAppIdLoader(url: URLS.env.smoochVendorAppId, client: http)
    }
    
    private static func buildTokenLoader(http: HTTPClient) -> RemoteClientTokenLoader {
        return RemoteClientTokenLoader(url: URLS.env.smoochVendorToken, client: http)
    }
    
    private static func buildIdentityController(http: HTTPClient, storage: Storage, accountInfo: IdentityInfo) -> IdentityStoreController {
        return IdentityStoreController(url: URLS.env.identityStore, httpClient: http, identityInfo: accountInfo, storage: storage)
    }
}
