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
    
    var unreadMessages: Int {
        return Int(conversation?.unreadCount ?? 0)
    }
    
    private var conversation: SKTConversation?
    
    override init() {
        super.init()
        Smooch.conversation()?.delegate = self
        conversation = Smooch.conversation()
    }
    
    func showConversation() {
        Smooch.show()
    }
    
    func unreadMessagesCountDidChange(_ onChange: (Int) -> Void) {
        onChange(unreadMessages)
    }
}
