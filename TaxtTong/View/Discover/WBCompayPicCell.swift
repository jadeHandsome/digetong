//
//  WBCompayPicCell.swift
//  TaxtTong
//
//  Created by ling on 2017/7/27.
//  Copyright © 2017年 ling. All rights reserved.
//

import UIKit

class WBCompayPicCell: UITableViewCell {


    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var utimeLabel: UILabel!
    
    var viewModal: [String: AnyObject] = [:] {
        didSet {

            if let img = viewModal["img"] as? String {
                leftImageView.setImageWith(URL.init(string: img)!)
            }
            titleLabel.text = viewModal["title"] as? String ?? ""
            utimeLabel.text = Tool.transFormatData(viewModal["utime"] as! Int)
            
        }
    }
}
