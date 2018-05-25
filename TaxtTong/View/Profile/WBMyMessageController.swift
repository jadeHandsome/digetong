//
//  WBCommonTableController.swift
//  TaxtTong
//
//  Created by ling on 2017/7/15.
//  Copyright © 2017年 ling. All rights reserved.
//

import UIKit
import MJRefresh
import SVProgressHUD

class WBMyMessageController: WBBaseViewController {
    
    var mTableView: UITableView!
    var cellId: String?
    var listArr = [[String: AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        renderUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        mTableView.mj_header.beginRefreshing()
    }
    
}

extension WBMyMessageController : UITableViewDelegate,UITableViewDataSource {
    
    func renderUI() {
        
        title = "我的消息"
        
        view.backgroundColor = UIColor().getRGB(r: 236, g: 236, b: 236)
        
        mTableView = UITableView.init(frame: CGRect(x: 0, y: 80, width: UIScreen().get_ScreenWidth(), height: UIScreen().get_ScreenHeight()))
        mTableView.backgroundColor = view.backgroundColor
        mTableView.tableFooterView = UIView.init(frame: CGRect.zero)
        mTableView.delegate = self
        mTableView.dataSource = self
        mTableView.register(UINib.init(nibName: "WBMyMessageCell", bundle: nil), forCellReuseIdentifier: "WBMyMessageCell")
        
        let header = MJRefreshNormalHeader()
        header.setRefreshingTarget(self, refreshingAction: #selector(requestData))
        mTableView.mj_header = header
        
        view.addSubview(mTableView)
        
        
    }
    
    func requestData() {
        
        WBNetworkManager.shared.requestMyMessage { (arr) in
            self.listArr = arr
            self.mTableView?.reloadData()
            self.mTableView.mj_header.endRefreshing()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listArr.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = listArr[indexPath.row]
        let cellId = "WBMyMessageCell";
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! WBMyMessageCell
        cell.viewModal = item
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let item = listArr[indexPath.row]
        let muid = item["muid"] as? Int ?? 0
        let state = item["state"] as? Int ?? 1
        let vc = WBMyMessageDetailController()
        vc.muid = muid
        vc.state = state
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let item = listArr[indexPath.row]
        let muid = item["muid"] as? Int ?? 0
        WBNetworkManager.shared.requestDeleteMyMessage(muid: muid) { (code) in
            if code == 200{
                SVProgressHUD.showSuccess(withStatus: "删除成功")
                self.listArr.remove(at: indexPath.row)
                self.mTableView.reloadData()
            }else{
                SVProgressHUD.showError(withStatus: "删除失败")
            }
        }
    }
}
