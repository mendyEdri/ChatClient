//
//  ChatConversationMock.swift
//  Integration
//
//  Created by Mendy Edri on 12/02/2020.
//  Copyright © 2020 CWT. All rights reserved.
//

import Foundation
import TDDChatProject

class ChatConversationMock: ChatConversation {
    
    var isConversationShowed: Bool = false
    var unreadMessages: Int = -1
    var unreadMessagesDidChangeCompletions = [(Int) -> Void]()
    
    var settings: ConversationSettings = ConversationSettings(email: "", userId: "", cwtJWT: "")
    
    var email: String = ""
    var userId: String = ""
    var cwtToken: String = ""
    
    func showConversation() {
        isConversationShowed = true
    }
    
    func update(userId: String) {
        self.userId = userId
    }
        
    func unreadMessagesCountDidChange(_ onChange: @escaping (Int) -> Void) {
        unreadMessagesDidChangeCompletions.append(onChange)
    }
}
