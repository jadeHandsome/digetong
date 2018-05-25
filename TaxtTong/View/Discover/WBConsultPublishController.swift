//
//  WBConsultPublishController.swift
//  TaxtTong
//
//  Created by ling on 2017/8/16.
//  Copyright © 2017年 ling. All rights reserved.
//

import UIKit
import SVProgressHUD

class WBConsultPublishController: WBBaseViewController {

    @IBOutlet weak var sureBtn: UIButton!
    @IBOutlet weak var titleTxtField: UITextField!
    @IBOutlet weak var contentTxtView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "发布咨询"
        sureBtn = UIButton().makeRadius(target: sureBtn, borderRadius: 5.0, text: "提交")
        
    }

    @IBAction func clickSure(_ sender: UIButton) {
        
        if titleTxtField.text?.characters.count != 0 && contentTxtView.text.characters.count != 0 {
            
            WBNetworkManager.shared.requestPublishConsult(title: titleTxtField.text, content: contentTxtView.text, completion: { ( isSuccess) in
                
                if (isSuccess){
                    self.navigationController?.popViewController(animated: true)
                    SVProgressHUD.showSuccess(withStatus: "发布成功")
                }else{
                    SVProgressHUD.showError(withStatus: "发布失败")
                }
            })
        }
    }
    

}
