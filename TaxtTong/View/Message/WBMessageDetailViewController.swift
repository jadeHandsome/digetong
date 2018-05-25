//
//  WBMessageDetailViewController.swift
//  TaxtTong
//
//  Created by ling on 2017/7/26.
//  Copyright © 2017年 ling. All rights reserved.
//

import UIKit

class WBMessageDetailViewController: WBBaseViewController {
    
    @IBOutlet weak var topImgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentTxtView: UITextView!
    @IBOutlet weak var addressTxtView: UITextView!
    @IBOutlet weak var contactPersonLabel: UILabel!
    @IBOutlet weak var contactPersonButton: UIButton!
    @IBOutlet weak var utimeLabel: UILabel!
    
    var item: [String: AnyObject]?
    
    convenience init(item: [String: AnyObject]){
        self.init(nibName: "WBMessageDetailViewController", bundle: nil)
        self.item = item
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "需求信息详情"
        if let img = item?["img"] as? String {
            topImgView.sd_setImage(with: URL.init(string: img))
        }
        if let timeStr = item?["utime"] as? String {
            let timestamp = Int(timeStr) ?? 0
            utimeLabel.text = Tool.transFormatData(timestamp)
        }
        titleLabel.text = item?["title"] as? String ?? ""
        contactPersonLabel.text = item?["contactPerson"] as? String ?? ""
        contactPersonButton.setTitle(item?["contactPhone"] as? String ?? "", for: .normal)
        contactPersonButton.contentHorizontalAlignment = .left
        contentTxtView.text = item?["content"] as? String ?? ""
        addressTxtView.text = item?["address"] as? String ?? ""
        contentTxtView = Tool.contentSize(toFit: contentTxtView)
        addressTxtView = Tool.contentSize(toFit: addressTxtView)
    }

    @IBAction func callPhone(_ sender: UIButton) {
        Tool.callPhone(sender.titleLabel?.text)
    }

}
