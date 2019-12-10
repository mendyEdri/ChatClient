//
//  ViewController.swift
//  TDDChatProject
//
//  Created by Mendy Edri on 07/11/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import UIKit

public class ChatDefaultComposiotion {
    
    static var instance: ChatDefaultComposiotion = ChatDefaultComposiotion() {
        didSet {
            print("SET ONCE")
        }
    }
    
    private var clientManager: ClientManager?
    
    func manager() -> ClientManager {
        let smoochClient = SmoochChatClient()
        let httpClient = URLSessionHTTPClient()
        let storage = UserDefaultsStorage()
        
        let managerClients = ClientManagerClients(
            chatClient: smoochClient,
            httpClient: httpClient,
            jwtClient: Jwt(),
            storage: storage)
        
        clientManager = ClientManager(clients: managerClients)
        return clientManager!
    }
}

class ViewController: UIViewController {

    let chatComposition = ChatDefaultComposiotion()
    override func viewDidLoad() {
        super.viewDidLoad()
        startChat()
    }

    
    func startChat() {
        chatComposition.manager().prepare { result in
            print("Done Prepare: \(result)")
        }
    }

}

