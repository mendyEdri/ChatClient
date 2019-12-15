//
//  ViewController.swift
//  TDDChatProject
//
//  Created by Mendy Edri on 07/11/2019.
//  Copyright © 2019 CWT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //startChat()
    }
    
    func startChat() {
        ChatDefaultComposition.manager.prepare { result in
            print("Done Prepare: \(result)")
        }
    }

}

