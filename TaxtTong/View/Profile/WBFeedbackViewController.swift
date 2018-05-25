//
//  WBFeedbackViewController.swift
//  TaxtTong
//
//  Created by ling on 2017/7/15.
//  Copyright © 2017年 ling. All rights reserved.
//

import UIKit
import SVProgressHUD

class WBFeedbackViewController: WBBaseViewController,UITextViewDelegate {

    @IBOutlet weak var sureButton: UIButton!
    @IBOutlet weak var txtView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        title = "用户反馈"
        
        sureButton = UIButton().makeRadius(target: sureButton, borderRadius: 5, text: "提交")
        
        txtView.becomeFirstResponder()
    }
    

    
    

    @IBAction func clickSure(_ sender: UIButton) {
        
        WBNetworkManager.shared.requestFeedback(text: txtView.text) { (isSuccess) in
            if(isSuccess){
                SVProgressHUD.showSuccess(withStatus: "发送成功")
                self.navigationController?.popViewController(animated: true)
            }else{
                SVProgressHUD.showSuccess(withStatus: "发送失败")
            }
        }
    }
}
