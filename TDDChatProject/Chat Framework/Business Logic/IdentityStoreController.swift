//
//  IdentityStoreController.swift
//  TDDChatProject
//
//  Created by Mendy Edri on 24/11/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import Foundation

public final class IdentityStoreController {
    
    private let url: URL
    // considure make it private and fix tests
    internal let loader: RemoteIdentityStoreLoader
    internal let persistent: ChatPersistent
    
    public init(url: URL, httpClient: ChatHTTPClient, storage: Storage) {
        self.url = url
        self.loader = RemoteIdentityStoreLoader(client: httpClient)
        self.persistent = ChatPersistent(storage: storage)
    }
    
    func start(_ completion: @escaping () -> Void) {
        // api should be requested only once per user, if the id is saved locally, ignore.
        guard avoidRequestIfUserIDIsSaved() == false else { return }

        loader.load(from: url, completion: { [weak self] result in
            switch result {
            case let .success(item):
                self?.save(item.responseHeader.res?.ops.first?.externalID)
                
            case .failure(_):
                break
            }
            completion()
        })
    }
    
    private func save(_ value: String?) {
        guard let userId = value else { return }
        persistent.saveVendor(userId: userId)
    }
    
    private func avoidRequestIfUserIDIsSaved() -> Bool {
        return (persistent.getVendorUserId() != nil)
    }
}
