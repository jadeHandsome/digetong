//
//  RepairDetailViewController.swift
//  TaxtTong
//
//  Created by ling on 2017/8/22.
//  Copyright © 2017年 ling. All rights reserved.
//

import UIKit
import SVProgressHUD

class RepairDetailViewController: WBBaseViewController,UIActionSheetDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionTxtView: UITextView!
    @IBOutlet weak var addressTxtView: UITextView!
    @IBOutlet weak var contactPersonButton: UIButton!
    @IBOutlet weak var personLabel: UILabel!
    @IBOutlet weak var utimeLabel: UILabel!
    @IBOutlet weak var topImgView: UIImageView!
    
    var item: [String: AnyObject]?
//    let para = BMKNaviPara()
//    
//    lazy var sheet: UIAlertController = {
//    
//        let coordinate = UserDefaults.init().getUserDefaults(key: LOCATION_KEY) as? [String:Double]
//        let lat1 = self.item?["latitude"] as? Double ?? 0
//        let lng1 = self.item?["longitude"] as? Double ?? 0
//        let lat2 = coordinate?["latitude"]  ?? 0
//        let lng2 = coordinate?["longitude"] ?? 0
//        
//        let startNade = BMKPlanNode.init()
//        startNade.pt.longitude = lng2
//        startNade.pt.latitude = lat2
//        let endNode = BMKPlanNode.init()
//        endNode.pt.longitude = lng1
//        endNode.pt.latitude = lat1
//        
//        self.para.startPoint = startNade
//        self.para.endPoint = endNode
//        
//        let isPara = lat1 != 0 && lng1 != 0 && lat2 != 0 && lng2 != 0
//        
//        var sheet =  UIAlertController.init(title: "请选择出行方式", message: nil, preferredStyle: .actionSheet)
//    
//        let actionNav = UIAlertAction.init(title: "导航", style: .destructive, handler: { (action) in
//            if(isPara){
//                BMKNavigation.openBaiduMapNavigation(self.para)
//            }
//        })
//        let actionRide = UIAlertAction.init(title: "骑行", style: .default, handler: { (action) in
//            if(isPara){
//                BMKNavigation.openBaiduMapRide(self.para)
//            }
//        })
//        let actionWake = UIAlertAction.init(title: "步行", style: .default, handler: { (action) in
//            if(isPara){
//                BMKNavigation.openBaiduMapWalk(self.para)
//            }
//        })
//        let actionCancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
//        
//        sheet.addAction(actionNav)
//        sheet.addAction(actionRide)
//        sheet.addAction(actionWake)
//        sheet.addAction(actionCancel)
//        
//        return sheet
//    }()
    
    convenience init(item: [String: AnyObject]){
        self.init(nibName: "RepairDetailViewController", bundle: nil)
        self.item = item
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "详情"
        navItem.rightBarButtonItem = UIBarButtonItem.init(title: "收藏", target: self, action: #selector(clickCollect))
        
        if let img = item?["img"] as? String {
            topImgView.sd_setImage(with: URL.init(string: img))
        }
        if let timestamp = item?["utime"] as? Int {
            utimeLabel.text = Tool.transFormatData(timestamp)
        }
        nameLabel.text = item?["name"] as? String ?? ""
        contactPersonButton.setTitle(item?["phone"] as? String ?? "", for: .normal)
        contactPersonButton.contentHorizontalAlignment = .left
        personLabel.text = item?["contactPerson"] as? String ?? ""
        descriptionTxtView.text = item?["description"] as? String ?? ""
        addressTxtView.text = item?["address"] as? String ?? ""
        descriptionTxtView = Tool.contentSize(toFit: descriptionTxtView)
        addressTxtView = Tool.contentSize(toFit: addressTxtView)
    }
    
    @IBAction func clickPhone(_ sender: UIButton) {
        
        Tool.callPhone(sender.titleLabel?.text)
    }
    
    @IBAction func clickNavigation(_ sender: UIButton) {
        
        let coordinate = UserDefaults.init().getUserDefaults(key: LOCATION_KEY) as? [String:Double]
        let lat1 = self.item?["latitude"] as? Double ?? 0
        let lng1 = self.item?["longitude"] as? Double ?? 0
        let lat2 = coordinate?["latitude"]  ?? 0
        let lng2 = coordinate?["longitude"] ?? 0
        
        
        let vc = PhoneGPSViewController()
        vc.startLat = lat2
        vc.startLng = lng2
        vc.endLat = lat1
        vc.endLng = lng1
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func clickCollect() {
        
        if let gid = item?["gid"] as? Int {
            WBNetworkManager.shared.requestCollectRepair(gid: gid) { (isSuccess) in
                if isSuccess{
                    SVProgressHUD.showSuccess(withStatus: "收藏成功")
                }else{
                    SVProgressHUD.showError(withStatus: "收藏失败")
                }
            }
        }
    }

}
