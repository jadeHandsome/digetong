//
//  WBCompanyCarCell.swift
//  TaxtTong
//
//  Created by ling on 2017/7/27.
//  Copyright © 2017年 ling. All rights reserved.
//

import UIKit

class WBCompanyCarCell: UITableViewCell {

    @IBOutlet weak var leftImgView: UIImageView!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var contactPhoneButton: UIButton!
    @IBOutlet weak var addButton: UIButton!

    @IBOutlet weak var leftImgViewW: NSLayoutConstraint!
    
    var tid: Int!
    
    var viewModal: [String: AnyObject] = [:] {
        didSet {

            if let img = viewModal["listImg"] as? String{
                let url = URL.init(string: img)
                if  url != nil {
                    leftImgView.setImageWith(url!)
                }
            }
            
            companyLabel.text = viewModal["name"] as? String ?? ""
            addressLabel.text = viewModal["address"] as? String ?? ""
            contactPhoneButton.setTitle(viewModal["contactnumber"] as? String ?? "", for: .normal)
            
            tid = viewModal["tid"] as! Int
        }
    }
    
    @IBAction func clickAdd(_ sender: UIButton) {
        
        NotificationCenter().post(name: SEND_ADDCOMPANY_NOTIF, dict: ["tid":tid])
    }
    

    @IBAction func clickPhone(_ sender: UIButton) {
        
        Tool.callPhone(sender.titleLabel?.text)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if isIphone5 {
            leftImgViewW.constant = 90
        }
    }
}
