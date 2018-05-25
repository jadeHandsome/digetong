//
//  WBCompanyNotifCell.swift
//  TaxtTong
//
//  Created by ling on 2017/8/15.
//  Copyright © 2017年 ling. All rights reserved.
//

import UIKit

class WBCompanyNotifCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var utimeLabel: UILabel!
    
    
    var viewModal: [String: AnyObject] = [:] {
        didSet {
            
            titleLabel.text = viewModal["title"] as? String ?? ""
            utimeLabel.text = Tool.transFormatData(viewModal["utime"] as! Int)
        }
    }
    
}
