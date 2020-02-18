//
//  ClientUI.swift
//  TDDChatProject
//
//  Created by Mendy Edri on 15/12/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import Foundation
import UIKit

protocol ClientUI {
    func openConversation(on navigation: UINavigationController)
    func closeConversation()
    func onRefreshToken(state: ClientMediator.RefreshState)
    var unreadMessages: Int { get }
}

