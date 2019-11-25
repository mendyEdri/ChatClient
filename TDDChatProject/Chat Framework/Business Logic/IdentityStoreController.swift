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
    // TODO: considure make it private and fix tests
    internal let loader: RemoteIdentityStoreLoader

    public typealias Store = (storage: Storage, key: String)
    private let store: Store
    
    public init(url: URL, httpClient: ChatHTTPClient, store: Store) {
        self.url = url
        self.loader = RemoteIdentityStoreLoader(client: httpClient)
        self.store = store
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
    
    private func delete() {
        store.storage.delete(key: store.key)
    }
    
    private func save(_ value: String?) {
        guard let userId = value else { return }
        store.storage.save(value: userId, for: store.key)
    }
    
    private func avoidRequestIfUserIDIsSaved() -> Bool {
        return (store.storage.value(for: store.key) != nil)
    }
}
