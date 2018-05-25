//
//  WBCompayHeaderView.swift
//  TaxtTong
//
//  Created by ling on 2017/7/27.
//  Copyright © 2017年 ling. All rights reserved.
//

import UIKit

class WBCompayHeaderView: UIView {
    
    var contentView: UIView?
    @IBOutlet weak var cellTypeLabel: UILabel!
    @IBOutlet weak var headerView: UIImageView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        load_init()
    }
    
    static func newInstance() -> WBCompayHeaderView?{
        let nibView = Bundle.main.loadNibNamed("WBCompayHeaderView", owner: nil, options: nil)
        if let view = nibView?.first as? WBCompayHeaderView{
            return view
        }
        return nil
    }
    
    func load_init(){
    }
    
    @IBAction func clickTypeBtn(_ sender: UIButton) {
        
        NotificationCenter().post(name: SEND_COMPANY_HEADER_BTN, dict: ["tag":sender.tag])
    }
  
}
