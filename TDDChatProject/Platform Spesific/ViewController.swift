//
//  ViewController.swift
//  TDDChatProject
//
//  Created by Mendy Edri on 07/11/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var switcher: UISwitch!
    @IBOutlet weak var unreadLabel: UILabel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        statusLabel.text = ""
        switcher.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
        switcher.isOn = Configuration.env == .production
        unreadLabel.text = "\(Chat.shared.unreadMessagesCount) Unread messages in your inbox"
        onUnreadChangeUpdateLabel()
    }

    @IBAction func didTouchOpenChat(_ sender: Any) {
        startAnimating()
        Chat.shared.showWhenReady { [weak self] result in
            self?.stopAnimating()
            self?.statusLabel(from: result)
        }
    }
    
    @IBAction func logout() {
        statusLabel.text = "Logging out.."
        startAnimating()
        
        Chat.shared.logout {
            self.statusLabel.text = ""
            self.stopAnimating()
        }
    }
    
    @objc func switchValueDidChange(_ switch: UISwitch) {
        logout()
        if switcher.isOn {
            Configuration.env = .production
        } else {
            Configuration.env = .stage
        }
    }
    
    private func onUnreadChangeUpdateLabel() {
        Chat.shared.unreadMessagesCountDidChange { count in
            self.unreadLabel.text = "\(count) Unread messages in your inbox"
        }
    }
    
    // MARK: Helpers
    
    private func statusLabel(from result: ClientMediator.ClientState) {
        switch result {
        case .ready:
            statusLabel.text = "Chat is Ready"
        case .notReady:
            statusLabel.text = "Chat is Not Ready"
        case let .failed(error):
            statusLabel.text = "Chat Failed \(error)"
        }
    }
    
    private func startAnimating() {
        activityIndicator.startAnimating()
    }
    
    private func stopAnimating() {
        activityIndicator.stopAnimating()
    }
}

/// facade of ClientMediator and ChatConversation
final class Chat {
    public static let shared = Chat()
    
    private var mediator: ClientMediator = ChatDefaultComposition.manager
    private var conversation: ChatConversation = SmoochConversation(email: "de@yopmail.com", userId: "87e4f53d-a284-489a-bffd-e15f4282d90a", cwtJWT: "Bearer eyJhbGciOiJSUzUxMiIsImtpZCI6InRva2VuQ2VydCJ9.eyJzY29wZSI6WyJvcGVuaWQiLCJwcm9maWxlIl0sImNsaWVudF9pZCI6IkN3dFRvR29PYXV0aENsaWVudCIsImp3dE9BdXRoIjoiQjZRWVE5OU10VG9PR2NTdExtZTJPcnRuQVl5b3RwRkIiLCJpZG1FbWFpbCI6ImRlQHlvcG1haWwuY29tIiwibGFzdE5hbWUiOiJJRE0iLCJ0b3BJZCI6IkE6NUEyQTUiLCJyb2xlcyI6WyJ0cmF2ZWxlciIsImFycmFuZ2VyIl0sInRyYXZlbGVyRW1haWwiOiJkZUB5b3BtYWlsLmNvbSIsInRyYXZlbGVyVHlwZUdVSUQiOiJBOjQwNEVBIiwic3ViSWQiOiJBOjVBMkI2IiwiZmlyc3ROYW1lIjoiREUiLCJpZCI6Ijg3ZTRmNTNkLWEyODQtNDg5YS1iZmZkLWUxNWY0MjgyZDkwYSIsIjNyZFBhcnR5U3luY0lkIjoiVEE2MzlOWkxOSyIsInRyYXZlbGVyR1VJRCI6IkE6NDA0RkQ2MDgiLCJ1c2VybmFtZSI6ImRlQHlvcG1haWwuY29tIiwiZXhwIjoxNTgxMDA2MDUyfQ.ODWFzyUD6LVSKHwOq-i1ipMXpybdVMBmDLz7EbygrkMllkkLMU3QcnAtltxw85InHiOh2Xpkc1W9CPwLJw6ccfQ_gblxHz6AlImhoN9NIqt-m2zirhPVbOB7IzKO92_ZZ9sf0U3Fw2SyAIKdoeaebgNEvPTRH2lE63HEeN4FGwZh5go-qvCdCJCBVG6yTBwpigOj4XkarGvVCsmchyv8t8TAHxJnKD_r1RuMVUKgg9YW4TuQNxD7dOA5s91mvrSmmBDg0H-Jq_a9DzsA0TTaTQGX6YU3RhORGFBOsvTtYOURHdEm9TDsQcnwjj0a3D1VC59h73CexmFa_5xddxLehw")
    
    private init() {}
    
    func showConversation() {
        conversation.showConversation()
    }
    
    func prepare(_ completion: @escaping (ClientMediator.ClientState) -> Void) {
        mediator = ChatDefaultComposition.manager
        mediator.prepare(completion)
    }
    
    func logout(_ done: @escaping () -> Void) {
        mediator.logout { _ in done() }
    }
    
    func showWhenReady(_ completion: ((ClientMediator.ClientState) -> Void)? = nil) {
        prepare { [weak self] result in
            if self?.mediator.isReady() ?? false {
                self?.showConversation()
            }
            completion?(result)
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
}

protocol UserData {
    var email: String { get }
    var userId: String { get }
    var cwtToken: String { get }
}
