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
    private let storage: Storage
    private let userIdSaveKey: String
    
    public enum Result {
        case success(String)
        case failure(Error)
    }
    
    public init(url: URL, httpClient: ChatHTTPClient, store: Store) {
        self.url = url
        self.loader = RemoteIdentityStoreLoader(client: httpClient)
        self.storage = store.storage
        self.userIdSaveKey = store.key
    }
    
    func start(_ completion: @escaping (Result) -> Void) {
        if let avoidRequestUserSavedLocally = savedUserId() {
            return completion(.success(avoidRequestUserSavedLocally))
        }

        loader.load(from: url, completion: { [weak self] result in
            guard let self = self else { return }
            
            completion(self.mapCompletion(from: result))
        })
    }
    
    private func delete() {
        storage.delete(key: userIdSaveKey)
    }
    
    private func save(_ value: String?) {
        guard let userId = value else { return }
        storage.save(value: userId, for: userIdSaveKey)
    }
    
    private func savedUserId() -> String? {
        return storage.value(for: userIdSaveKey) as? String
    }
    
    // MARK: - Helpers
    
    private func mapCompletion(from result: RemoteIdentityStoreLoader.Result) -> Result {
        switch result {
        case let .success(identityStore):
            guard let userID = externalID(from: identityStore) else {
                return .failure(RemoteIdentityStoreLoader.Error.invalidData)
            }
            self.save(userID)
            return .success(userID)
            
        case let .failure(error):
            return .failure(error)
        }
    }
    
    private func externalID(from item: IdentityStoreModel) -> String? {
        return item.responseHeader.res?.ops.first?.externalID
    }
}
