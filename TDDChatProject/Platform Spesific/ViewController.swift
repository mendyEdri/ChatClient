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
        
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        statusLabel.text = ""
    }

    @IBAction func didTouchOpenChat(_ sender: Any) {
        startAnimating()
        Chat.shared.showWhenReady { [weak self] result in
            self?.stopAnimating()
            self?.statusLabel(from: result)
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
    private var conversation: ChatConversation = SmoochConversation()
    
    private init() {}
    
    func showConversation() {
        conversation.showConversation()
    }
    
    func prepare(_ completion: @escaping (ClientMediator.ClientState) -> Void) {
        mediator.prepare(completion)
    }
    
    func showWhenReady(_ completion: ((ClientMediator.ClientState) -> Void)? = nil) {
        prepare { [weak self] result in
            if self?.mediator.isReady() ?? false {
                self?.showConversation()
            }
            completion?(result)
        }
    }
}
