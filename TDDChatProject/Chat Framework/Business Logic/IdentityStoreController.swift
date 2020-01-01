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
    
    internal let loader: RemoteIdentityStoreLoader

    private let storage: Storage
    private let userIdSaveKey: String
    private let key = "IdentityStoreController.identityStoreKey"
    
    public enum Result {
        case success(String)
        case failure(Error)
    }
    
    public required init(url: URL, httpClient: HTTPClient, storage: Storage, key: String = "IdentityStoreController.identityStoreKey") {
        self.url = url
        self.loader = RemoteIdentityStoreLoader(url: url, client: httpClient)
        self.storage = storage
        self.userIdSaveKey = key
    }
    
    func registerIfNeeded(_ completion: @escaping ((Result) -> Void)) {
        if let avoidRequestSinceUserSavedLocally = savedUserId() {
            return completion(.success(avoidRequestSinceUserSavedLocally))
        }

        loader.load(completion: { [weak self] result in
            guard let self = self else { return }
            
            completion(self.mapResult(from: result))
        })
    }
    
    public func clearUserId() {
        delete()
    }
    
    private func delete() {
        storage.delete(key: userIdSaveKey)
    }
    
    private func save(_ value: String?) {
        guard let userId = value else { return }
        storage.save(value: userId, for: userIdSaveKey)
    }
    
    internal func savedUserId() -> String? {
        return storage.value(for: userIdSaveKey) as? String
    }
    
    // MARK: - Helpers
    
    private func mapResult(from result: RemoteIdentityStoreLoader.Result) -> Result {
        switch result {
        case let .success(identityStore):
            guard let userID = externalID(from: identityStore)
                else {
                return .failure(RemoteIdentityStoreLoader.Error.invalidData)
            }
            self.save(userID)
            return .success(userID)
            
        case let .failure(error):
            return .failure(error)
        }
    }
    
    private func externalID(from item: IdentityStoreModel) -> String? {
        return oneOf(item.responseHeader.res?.ops.first?.externalID, item.responseHeader.record?.externalID)
    }
    
    func oneOf<T>(_ val1: T?, _ val2: T?) -> T? {
        if val1 != nil {
            return val1
        } else if val2 != nil {
            return val2
        }
        return nil
    }
}
