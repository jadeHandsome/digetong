//
//  PepairCarCell.swift
//  TaxtTong
//
//  Created by ling on 2017/7/17.
//  Copyright © 2017年 ling. All rights reserved.
//

import UIKit

class PepairCarCell: UITableViewCell {

    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!

    
    var viewModal: [String: AnyObject] = [:] {
        didSet {
            let url = URL.init(string: viewModal["img"] as? String ?? "")
            leftImageView.setImageWith(url!)
            
            nameLabel.text = viewModal["name"] as? String ?? ""
            addressLabel.text = viewModal["address"] as? String ?? ""
            
            areaLabel.text = "距离:\(viewModal["distance"] as? String ?? "")千米"
        }
    }
}
