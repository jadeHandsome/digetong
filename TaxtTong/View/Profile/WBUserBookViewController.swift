//
//  WBUserBookViewController.swift
//  TaxtTong
//
//  Created by ling on 2017/8/21.
//  Copyright © 2017年 ling. All rights reserved.
//

import UIKit

class WBUserBookViewController: WBBaseViewController {

    @IBOutlet weak var txtView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "用户使用协议"
        
        var text = txtView.text
        text = text! + "\n \n \n"
        txtView.text = text
    }


}
