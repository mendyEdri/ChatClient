//
//  SmoochConversation.swift
//  TDDChatProject
//
//  Created by Mendy Edri on 03/02/2020.
//  Copyright © 2020 CWT. All rights reserved.
//

import Foundation
import Smooch

final class SmoochConversation: NSObject, ChatConversation, SKTConversationDelegate {
    
    private var conversation: SKTConversation?
    private var unreadChanged: ((Int) -> Void)?
    private var metadata: Metadata
    
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
    
    init(email: String, userId: String, cwtJWT: String) {
        conversation = Smooch.conversation()
        metadata = Metadata(email: email, userId: userId, cwtJWT: cwtJWT)
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
        return SKTMessage.init(text: message.text ?? "", payload: message.payload, metadata: metadata.keyValues())
    }
   
}
