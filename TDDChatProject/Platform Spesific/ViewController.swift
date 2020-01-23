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
        self.activityIndicator.isHidden = true
        self.activityIndicator.hidesWhenStopped = true
        //startChat()
    }
    
    func buttonSelected() {
        ChatDefaultComposition.manager.prepare { result in
            print("Done Prepare: \(result)")
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
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

