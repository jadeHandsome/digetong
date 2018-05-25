//
//  WBConsultDetailController.swift
//  TaxtTong
//
//  Created by ling on 2017/8/16.
//  Copyright © 2017年 ling. All rights reserved.
//

import UIKit

class WBConsultDetailController: WBBaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var questionTxtView: UITextView!
    @IBOutlet weak var answerTxtView: UITextView!
    @IBOutlet weak var answerView: UIView!
    
    var cid: Int!
    
    convenience init(cid: Int){
        self.init(nibName: "WBConsultDetailController", bundle: nil)
        self.cid = cid
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "咨询内容"
        
        WBNetworkManager.shared.requestConsultDetail(cid: cid) { (dic, isSuccess) in
            
            self.titleLabel.text = dic["title"] as? String ?? ""
            self.questionTxtView.text = dic["content"] as? String ?? ""
            self.questionTxtView = Tool.contentSize(toFit: self.questionTxtView)
            
            self.answerTxtView.text = dic["replycontent"] as? String ?? ""
            self.answerTxtView = Tool.contentSize(toFit: self.answerTxtView)
            if (self.answerTxtView.text.characters.count == 0){
                self.answerView.isHidden = true
            }
            
        }

    }



}
