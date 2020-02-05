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
    
    override init() {
        super.init()
        Smooch.conversation()?.delegate = self
    }
    
    func showConversation() {
        Smooch.show()
    }
}
