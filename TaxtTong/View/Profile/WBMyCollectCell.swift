//
//  WBMyCollectCell.swift
//  TaxtTong
//
//  Created by ling on 2017/7/15.
//  Copyright © 2017年 ling. All rights reserved.
//

import UIKit

class WBMyCollectCell: UITableViewCell {

    
    @IBOutlet weak var leftImgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var gid: Int?
    var index: Int!
    
    var viewModal: [String: AnyObject] = [:] {
        didSet {
            let url = URL.init(string: viewModal["img"] as? String ?? "")
            leftImgView.setImageWith(url!)
            nameLabel.text = viewModal["name"] as? String ?? ""
            addressLabel.text = viewModal["address"] as? String ?? ""
            gid = viewModal["gid"] as? Int
            
            
            let coordinate = UserDefaults.init().getUserDefaults(key: LOCATION_KEY) as? [String:Double]
            let lat1 = viewModal["latitude"] as? Double ?? 0
            let lng1 = viewModal["longitude"] as? Double ?? 0
            let lat2 = coordinate?["latitude"]  ?? 0
            let lng2 = coordinate?["longitude"] ?? 0
            let str = Tool.getGreatCircleDistance(lat1, lng1: lng1, lat2: lat2, lng2: lng2)
            distanceLabel.text = "距离:\(str as? String ?? "")千米"
            
            if(lat2 == 0){
                distanceLabel.isHidden = true
            }
        }
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
    }
    

    
    

    
}
