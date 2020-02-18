//
//  ViewController.swift
//  TDDChatProject
//
//  Created by Mendy Edri on 07/11/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import UIKit
import lit_networking

class ViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var switcher: UISwitch!
    @IBOutlet weak var unreadLabel: UILabel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        activityIndicator.hidesWhenStopped = true
        statusLabel.text = ""
        switcher.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
        switcher.isOn = Configuration.env == .production
        unreadLabel.text = "\(ChatDefaultComposition.facade.unreadMessagesCount) Unread messages in your inbox"
        onUnreadChangeUpdateLabel()
        
        ChatDefaultComposition.facade.settings(email: "de@yopmail.com", tokenAdapter: AccessTokenPingAdapter())
    }

    @IBAction func didTouchOpenChat(_ sender: Any) {
        startAnimating()
        ChatDefaultComposition.facade.showWhenReady { [weak self] result in
            self?.stopAnimating()
            self?.statusLabel(from: result)
        }
    }
    
    @IBAction func logout() {
        statusLabel.text = "Logging out.."
        startAnimating()
        
        ChatDefaultComposition.facade.logout {
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
        ChatDefaultComposition.facade.unreadMessagesCountDidChange { count in
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
