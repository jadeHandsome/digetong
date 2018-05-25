//
//  WBMyMessageCell.swift
//  TaxtTong
//
//  Created by ling on 2017/7/12.
//  Copyright © 2017年 ling. All rights reserved.
//

import UIKit

class WBMyMessageCell: UITableViewCell {

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var readLabel: UILabel!
    
    
    var viewModal: [String: AnyObject] = [:] {
        didSet {
            
            typeLabel.text = viewModal["type"] as? Int ?? 1 == 1 ? "【系统】":"【公司】"
            titleLabel.text = viewModal["title"] as? String ?? ""
            readLabel.text = viewModal["state"] as? Int ?? 1 == 1 ? "未读":"已读"
        }
    }
}
