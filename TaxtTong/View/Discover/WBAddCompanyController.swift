//
//  WBCompanyViewController.swift
//  TaxtTong
//
//  Created by ling on 2017/7/1.
//  Copyright © 2017年 ling. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh

enum WBCompanyType{
    case JOIN
    case UNJOIN
}

class WBAddCompanyController: WBBaseViewController {

    @IBOutlet weak var mTableView: UITableView!
    @IBOutlet weak var tableViewConstrollerB: NSLayoutConstraint!
    @IBOutlet weak var proButton: UIButton!
    @IBOutlet weak var cityButton: UIButton!
    
    let cellID = "WBCompanyCarCell"
    var listArr = [[String: AnyObject]]()
    var orignArr = [[String: AnyObject]]()
    var type : WBCompanyType?
    var pickerView: AreaPickerView!
    
    convenience init(type: WBCompanyType){
        self.init(nibName: "WBAddCompanyController", bundle: nil)
        self.type = type
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        renderUI()
        
        pickerView = AreaPickerView.init(frame: CGRect(x: 0, y: UIScreen.main.bounds.height - pickerH - 49, width: UIScreen.main.bounds.width, height: 220))
        self.view.addSubview(pickerView)
        pickerView.selectValue()
        pickerView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        NotificationCenter().addObserve(target: self, selector: #selector(receiveAreaNotif), name: SELECT_AREA_KEY)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        tableViewConstrollerB.constant = type == .JOIN ? 0 : 49
    }
    
  
    @IBAction func showArea(_ sender: UIButton) {
        pickerView.selectValue()
        pickerView.isHidden = false
    }
    
    func receiveAreaNotif() {
        
        let areaDic = UserDefaults().getUserDefaults(key: SELECT_AREA_KEY) as? Dictionary<String, Any>
        let cityName = areaDic?["cityName"] as? String ?? "广州"
        let proName = areaDic?["proName"] as? String ?? "广东"
        
        proButton.setTitle(proName, for: .normal)
        cityButton.setTitle(cityName, for: .normal)
        
        WBNetworkManager.shared.requestCompanyList(province: proName, city: cityName) { (arr, isSuccess) in
            self.listArr = arr
            self.orignArr = arr
            self.mTableView.reloadData()
        }
    }
    
}




extension WBAddCompanyController {
    
    func renderUI() {
        
        mTableView?.tableFooterView = UIView.init(frame: CGRect.zero)
        mTableView?.register(UINib.init(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
        
        let header = MJRefreshNormalHeader()
        header.setRefreshingTarget(self, refreshingAction: #selector(requestData))
        mTableView.mj_header = header
        
        let areaDic = UserDefaults().getUserDefaults(key: SELECT_AREA_KEY) as? Dictionary<String, Any>
        let cityName = areaDic?["cityName"] as? String ?? "广州"
        let proName = areaDic?["proName"] as? String ?? "广东"
        
        proButton.setTitle(proName, for: .normal)
        cityButton.setTitle(cityName, for: .normal)
        
        WBNetworkManager.shared.requestCompanyList(province: proName, city: cityName) { (arr, isSuccess) in
            self.listArr = arr
            self.orignArr = arr
            self.mTableView.reloadData()
        }
    }
    
    func requestData() {
        WBLoginViewModal.init().getUserInfo { (isSuccess) in
            if isSuccess && self.type != .JOIN {
                let userInfo = WBUserinfoManager.shared.userInfo
                let companystate = userInfo.companystate
                let tid = userInfo.tid
                if companystate == 2 && tid != NULL {
                    SVProgressHUD.showSuccess(withStatus: "审核通过")
                    let vc = WBCompanyViewController.init()
                    vc.title = "公司"
                    vc.tabBarItem.image = UIImage(named: "tabbar_gongsi")
                    vc.tabBarItem.selectedImage = UIImage(named: "tabbar_gongsi_highlighted")?.withRenderingMode(.alwaysOriginal)
                    vc.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor().getMainColor()], for: .highlighted)
                    let nav = WBNavigatorController(rootViewController: vc)
                    var vcArr = self.tabBarController?.viewControllers
                    vcArr?.replaceSubrange(Range(1..<2), with: [nav])
                    self.tabBarController?.setViewControllers(vcArr, animated: true)
                }else if(companystate == 3){
                    SVProgressHUD.showError(withStatus: "抱歉，审核不通过")
                }else if(companystate == 4){
                    SVProgressHUD.showInfo(withStatus: "您还没申请加入公司")
                }else {
                    SVProgressHUD.showInfo(withStatus: "暂没审核,请稍后") //companystate == 1
                }
            }
            self.mTableView.mj_header.endRefreshing()
        }
    }
}

extension WBAddCompanyController : UITableViewDelegate,UITableViewDataSource  {
    
    @objc func receiveAddInfo(sender: UIButton) {
        
        if self.type == .JOIN {
            SVProgressHUD.showInfo(withStatus: "请先退出原来的公司")
        }else{
            let VC = WBProfileDetailController()
            VC.isAddCompany = true
            VC.tid = sender.tag
            self.navigationController?.pushViewController(VC, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArr.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = listArr[indexPath.row]
        let cellId = cellID;
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! WBCompanyCarCell
        cell.viewModal = item
        cell.selectionStyle = .none
        
        let tid = item["tid"] as! Int
        cell.addButton.tag = tid
        cell.addButton.addTarget(self, action: #selector(receiveAddInfo(sender:)), for: .touchUpInside)
        

        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if isIphone5 {
            return 130
        }
        return 150
    }
    
}

extension WBAddCompanyController : UISearchBarDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count == 0 {
            listArr = orignArr
            mTableView.reloadData()
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        requestSearchList(searchKey: searchBar.text)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        requestSearchList(searchKey: searchBar.text)
    }
    
    func requestSearchList(searchKey: String?) {
        WBNetworkManager.shared.requestCompanySearchList(searchkey: searchKey) { (arr, isSuccess) in
            self.listArr = arr
            self.mTableView.reloadData()
        }
    }
}
