//
//  IdentityStoreController.swift
//  TDDChatProject
//
//  Created by Mendy Edri on 24/11/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import Foundation

final class IdentityStoreController {
    
    private let url: URL
    private let loader: RemoteIdentityStoreLoader
    private let persistent: ChatPersistent
    
    init(url: URL, httpClient: ChatHTTPClient, storage: Storage) {
        self.url = url
        self.loader = RemoteIdentityStoreLoader(client: httpClient)
        self.persistent = ChatPersistent(storage: storage)
    }
    
    func start() {
        // api should be requested only once per user, if the id is saved locally, ignore.
        guard persistent.getVendorUserId() == nil else { return }

        loader.load(from: url, completion: { [weak self] result in
            switch result {
            case let .success(item):
                self?.save(item.responseHeader.res?.ops.first?.externalID)
                
            case .failure(_):
                break
            }
        })
    }
    
    private func save(_ value: String?) {
        guard let userId = value else { return }
        persistent.saveVendor(userId: userId)
    }
    
}
