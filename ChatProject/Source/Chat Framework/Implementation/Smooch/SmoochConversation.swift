//
//  SmoochConversation.swift
//  ChatProject
//
//  Created by Mendy Edri on 03/02/2020.
//  Copyright © 2020 CWT. All rights reserved.
//

import Foundation
import Smooch

final class SmoochConversation: NSObject, ChatConversation, SKTConversationDelegate {
    
    private var conversation: SKTConversation?
    private var unreadChanged: ((Int) -> Void)?
    private var metadata: Metadata?
    
    var settings: ConversationSettings {
        didSet {
            metadata = Metadata(email: settings.email, userId: settings.userId, cwtJWT: settings.cwtJWT)
        }
    }
    
    var userId: String {
        didSet {
            settings.userId = self.userId
        }
    }
    
    var email: String {
        didSet {
            settings.email = self.email
        }
    }
    
    var cwtToken: String {
        didSet {
            settings.cwtJWT = self.cwtToken
        }
    }
    
    private struct Metadata {
        var email: String
        var userId: String
        var cwtJWT: String
        
        private enum Keys: String {
            case email, userId, cwtJWT
        }
        
        func keyValues() -> Dictionary<String, String> {
            return [Keys.email.rawValue: email, Keys.userId.rawValue: userId, Keys.cwtJWT.rawValue: cwtJWT]
        }
    }
    
    var unreadMessages: Int {
        return Int(conversation?.unreadCount ?? 0)
    }
    
    override init() {
        userId = ""
        email = ""
        cwtToken = ""
        
        settings = ConversationSettings(email: email, userId: userId, cwtJWT: cwtToken)
        conversation = Smooch.conversation()
    }
    
    func showConversation() {
        Smooch.conversation()?.delegate = self
        Smooch.show()
    }
    
    func unreadMessagesCountDidChange(_ onChange: @escaping (Int) -> Void) {
        unreadChanged = onChange
    }
    
    // MARK: - SKTConversationDelegate
    
    func conversation(_ conversation: SKTConversation, unreadCountDidChange unreadCount: UInt) {
        unreadChanged?(Int(unreadCount))
    }
    
    func conversation(_ conversation: SKTConversation, willSend message: SKTMessage) -> SKTMessage {
        guard let metadata = metadata?.keyValues() else { return message }
        
        return SKTMessage(text: message.text ?? "", payload: message.payload, metadata: metadata)
    }
   
}
