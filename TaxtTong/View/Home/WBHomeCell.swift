//
//  WBHomeCell.swift
//  TaxtTong
//
//  Created by ling on 2017/7/7.
//  Copyright © 2017年 ling. All rights reserved.
//

import UIKit

class WBHomeCell: UITableViewCell {

    @IBOutlet weak var bgImgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var viewModal: [String: AnyObject] = [:] {
        didSet {
            let url = URL.init(string: viewModal["img"] as? String ?? "")
            bgImgView.setImageWith(url!)
            
            titleLabel.text = viewModal["title"] as? String ?? ""
            
        }
    }
    
}
