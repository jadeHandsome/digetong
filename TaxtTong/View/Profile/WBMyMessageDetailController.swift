//
//  WBMyMessageDetailController.swift
//  TaxtTong
//
//  Created by ling on 2017/9/23.
//  Copyright © 2017年 ling. All rights reserved.
//

import UIKit

class WBMyMessageDetailController: WBBaseViewController {

    var muid: Int!
    var state: Int!
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WBNetworkManager.shared.requestMyMessageDetail(muid: muid) { (dic) in
            
            self.title = dic["title"] as? String ?? ""
            self.textView.text = dic["text"] as? String ?? ""
        }
        
        if state == 1 {
            WBNetworkManager.shared.requestMyMessageRead(muid: muid, completion: { (dic) in
                print(dic)
            })
        }
    }

    



}
