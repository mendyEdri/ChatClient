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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        buttonSelected()
    }
    
    func buttonSelected() {
        ChatDefaultComposition.manager.prepare { [weak self] result in
            print("Done Prepare: \(result)")
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
            }
        }
    }

    @IBAction func didTouchOpenChat(_ sender: Any) {
        if ChatDefaultComposition.manager.isReady() {
            return
        }
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
    }
}

