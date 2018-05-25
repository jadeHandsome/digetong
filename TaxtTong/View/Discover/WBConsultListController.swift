//
//  WBConsultListController.swift
//  TaxtTong
//
//  Created by ling on 2017/8/16.
//  Copyright © 2017年 ling. All rights reserved.
//

import UIKit
import SVProgressHUD

class WBConsultListController: WBBaseViewController {
    
    @IBOutlet weak var mTableView: UITableView!

    var listArr = [[String: AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        renderUI()
    }

}

extension WBConsultListController: UITableViewDelegate,UITableViewDataSource {
    
    func renderUI() {
        title = "咨询"
        navItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "message_navitem_edit"), style: .plain, target: self, action: #selector(pushPublish))
        mTableView?.tableFooterView = UIView.init(frame: CGRect.zero)
        
        WBNetworkManager.shared.requestConsultList { (arr, isSuccess) in
            self.listArr = arr
            self.mTableView.reloadData()
        }
    }
    
    func pushPublish() {
        navigationController?.pushViewController(WBConsultPublishController(), animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArr.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = listArr[indexPath.row]
        let cell = UITableViewCell(style: .default, reuseIdentifier: "WBConsultListController");
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = item["title"] as? String ?? ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = listArr[indexPath.row]
        navigationController?.pushViewController(WBConsultDetailController.init(cid: item["cid"] as! Int), animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let item = listArr[indexPath.row]
        let cid = item["cid"] as? Int ?? 0
        WBNetworkManager.shared.requestDeleteConsult(cid: cid) { (isSuccess) in
            if isSuccess {
                 SVProgressHUD.showSuccess(withStatus: "删除成功")
                 self.listArr.remove(at: indexPath.row)
                 self.mTableView.reloadData()
            }else{
                 SVProgressHUD.showError(withStatus: "删除失败")
            }
        }
    }
    
}
