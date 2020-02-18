//
//  ChatConversation.swift
//  ChatProject
//
//  Created by Mendy Edri on 03/02/2020.
//  Copyright © 2020 CWT. All rights reserved.
//

import Foundation

protocol ConversationMessages {
    var unreadMessages: Int { get }
    func unreadMessagesCountDidChange(_ onChange: @escaping (Int) -> Void)
}

protocol ChatConversation: ConversationMessages {
    func showConversation()
    var settings: ConversationSettings { get set }
}
