//
//  SmoochChatUI.swift
//  TDDChatProject
//
//  Created by Mendy Edri on 15/12/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import Foundation
import Smooch

class SmoochChatUI: ClientUI {
    
    var unreadMessages: Int = 0
    
    func openConversation(on navigation: UINavigationController) {
        guard let conversation = Smooch.newConversationViewController() else {
            return debugPrint("Smooch.newConversationViewController returns no view controller")
        }
        navigation.present(conversation, animated: true, completion: nil)
    }
    
    func closeConversation() {
        Smooch.close()
    }
    
    func onRefreshToken(state: ClientMediator.RefreshState) {
        switch state {
        case .start:
            break
            
        case .end:
            break
            
        }
    }
}
