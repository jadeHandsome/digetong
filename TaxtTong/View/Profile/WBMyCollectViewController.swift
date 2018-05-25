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

class WBMyCollectViewController: WBBaseViewController {
    
    var mTableView: UITableView?
    var listArr = [[String: AnyObject]]()
    let cellId: String = "WBMyCollectCell"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        renderUI()
    }
    
    
}

extension WBMyCollectViewController : UITableViewDelegate,UITableViewDataSource {
    
    func renderUI() {
        
        title = "我的收藏"
        view.backgroundColor = UIColor().getRGB(r: 236, g: 236, b: 236)
        
        mTableView = UITableView.init(frame: CGRect(x: 0, y: 80, width: UIScreen().get_ScreenWidth(), height: UIScreen().get_ScreenHeight()-80.0))
        mTableView?.backgroundColor = view.backgroundColor
        mTableView?.tableFooterView = UIView.init(frame: CGRect.zero)
        mTableView?.delegate = self
        mTableView?.dataSource = self
        mTableView?.register(UINib.init(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
        mTableView?.separatorStyle = .none
        view.addSubview(mTableView!)
        
        let header = MJRefreshNormalHeader()
        header.setRefreshingTarget(self, refreshingAction: #selector(requestData))
        mTableView?.mj_header = header
        mTableView?.mj_header.beginRefreshing()
    }
    
    func requestData() {
        
        WBNetworkManager.shared.requestMyCollect { (arr) in
            self.listArr = arr
            self.mTableView?.reloadData()
            self.mTableView?.mj_header.endRefreshing()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArr.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = listArr[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! WBMyCollectCell
        cell.viewModal = item
        cell.index = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = listArr[indexPath.row]
        navigationController?.pushViewController(RepairDetailViewController.init(item: item), animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let item = listArr[indexPath.row]
        if let gid = item["gid"] as? Int {
            WBNetworkManager.shared.requestDeleteMyCollect(gid: gid, completion: { (isSuccess) in
                if(isSuccess){
                    SVProgressHUD.showSuccess(withStatus: "删除成功")
                    self.mTableView?.mj_header.beginRefreshing()
                }else{
                    SVProgressHUD.showError(withStatus: "删除失败")
                }
            })
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isIphone5 {
            return 90
        }
        return 110
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 10))
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
}
