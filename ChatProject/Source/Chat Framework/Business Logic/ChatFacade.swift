//
//  ChatFacade.swift
//  ChatProject
//
//  Created by Mendy Edri on 11/02/2020.
//  Copyright © 2020 CWT. All rights reserved.
//

import Foundation
import lit_networking

/// Facade of ClientMediator and ChatConversation

final public class ChatFacade {
        
    private var mediator: ClientMediator
    private var conversation: ChatConversation
    
    func settings(email: String, tokenAdapter: AccessTokenAdapter) {
        let userId = parseUserId(from: mediator.userToken) ?? ""
        conversation.settings.email = email
        conversation.settings.userId = userId
        updateConversationSettings(tokenAdapter)
    }
    
    init(mediator: ClientMediator, conversation: ChatConversation) {
        self.mediator = mediator
        self.conversation = conversation
        observeMediatorUpdatesToken()
    }
    
    // MARK: API
    
    func logout(_ done: @escaping () -> Void) {
        mediator.logout { _ in done() }
    }
    
    func showWhenReady(_ completion: ((ClientMediator.ClientState) -> Void)? = nil) {
        prepare { [weak self] result in
            switch result {
            case .ready:
                self?.showConversation()
                
            default:
                break
            }
            completion?(result)
        }
    }
    
    private func observeMediatorUpdatesToken() {
        mediator.onVendorTokenUpdated { [weak self] newToken in
            guard let self = self else { return }
            
            self.conversation.settings.userId = self.parseUserId(from: newToken) ?? ""
        }
    }
    
    var unreadMessagesCount: Int {
        return conversation.unreadMessages
    }
    
    func unreadMessagesCountDidChange(_ completion: @escaping (Int) -> Void) {
        conversation.unreadMessagesCountDidChange { count in
            completion(count)
        }
    }
    
    private func showConversation() {
        conversation.showConversation()
    }
    
    private func prepare(_ completion: @escaping (ClientMediator.ClientState) -> Void) {
        mediator.prepare(completion)
    }
    
    private func parseUserId(from token: String?) -> String? {
        guard let token = token else { return nil }
        var jwt = Jwt()
        jwt.jwtString = token
        
        return jwt.value(for: "userId")
    }
    
    private func updateConversationSettings(_ adapter: AccessTokenAdapter) {
        adapter.requestAccessToken { [weak self] result in
            result.success { token in
                self?.conversation.settings.cwtJWT = "Bearer " + token
            }
        }
    }
}
