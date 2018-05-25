//
//  WBMessageCell.swift
//  TaxtTong
//
//  Created by ling on 2017/7/26.
//  Copyright © 2017年 ling. All rights reserved.
//

import UIKit

class WBMessageCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    var viewModal: [String: AnyObject] = [:] {
        didSet {
            print("viewModal:\(viewModal)")
            titleLabel.text = viewModal["title"] as? String ?? ""
            if let timestamp = viewModal["utime"] as? Int {
                dateLabel.text = Tool.transFormatData(timestamp)
            }
        }
    }
    
}
