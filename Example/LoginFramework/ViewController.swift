//
//  ViewController.swift
//  LoginFramework
//
//  Created by 王海晨 on 03/21/2016.
//  Copyright (c) 2016 王海晨. All rights reserved.
//

import UIKit
import LoginFramework

class ViewController: UIViewController {

    @IBOutlet weak var customTextfield: CustomTextField! {
        didSet {
            customTextfield.textColor = UIColor.blackColor()
            customTextfield.font = UIFont.systemFontOfSize(15)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

