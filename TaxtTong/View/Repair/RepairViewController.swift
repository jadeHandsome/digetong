//
//  RepairViewController.swift
//  TaxtTong
//
//  Created by ling on 2017/7/1.
//  Copyright © 2017年 ling. All rights reserved.
//

import UIKit
import MJRefresh

class RepairViewController: WBBaseViewController,BMKLocationServiceDelegate {

    @IBOutlet weak var mTableView: UITableView!
    let cellID = "PepairCarCell"
    
    var locationService: BMKLocationService!
    var listArr = [[String: AnyObject]]()
    var originArr = [[String: AnyObject]]()
    var areBtn: UIButton!
    var pickerView: AreaPickerView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        //启动导航
        BNCoreServices.getInstance().initServices("4pGluRHr03THIlibopPwcMuBwQBaTkF7")
        BNCoreServices.getInstance().setTTSAppId("10043527")
        BNCoreServices.getInstance().startAsyn({
            print("启动导航成功")
        }) {
            print("启动导航失败")
        }
        
        //定位
        locationService = BMKLocationService()
        //        locationService.allowsBackgroundLocationUpdates = true
        locationService.startUserLocationService()
        
        renderUI()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        locationService.delegate = self
        
        mTableView.mj_header.beginRefreshing()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        locationService.delegate = self
    }
    
    func didUpdate(_ userLocation: BMKUserLocation!) {
        let coordinate = ["latitude":userLocation.location.coordinate.latitude,"longitude":userLocation.location.coordinate.longitude]
        UserDefaults.init().saveUserDefaults(key: LOCATION_KEY, value: coordinate)
//        locationService.stopUserLocationService()
        let dic = UserDefaults().getUserDefaults(key: SELECT_AREA_KEY) as? Dictionary<String, Any>
        let title = dic?["cityName"] as? String ?? "广州"
        areBtn.setTitle(title, for: .normal)
        self.navItem.leftBarButtonItem = UIBarButtonItem.init(customView: areBtn)
        pickerView.selectValue()
        requestData()
    }
    
}

extension RepairViewController {
    
    func renderUI() {
        
        
        mTableView?.tableFooterView = UIView.init(frame: CGRect.zero)
        mTableView.separatorStyle = .none
        mTableView?.register(UINib.init(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
        
        navItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "message_navitem_edit"), style: .plain, target: self, action: #selector(pushEdit))
        
        let header = MJRefreshNormalHeader()
        header.setRefreshingTarget(self, refreshingAction: #selector(requestData))
        mTableView.mj_header = header
        
        let dic = UserDefaults().getUserDefaults(key: SELECT_AREA_KEY) as? Dictionary<String, Any>
        let img = UIImage.init(named: "location")
        let title = dic?["cityName"] as? String ?? "广州"
        areBtn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 60, height: 44))
        areBtn.setImage(img, for: .normal)
        areBtn.setTitle(title, for: .normal)
        areBtn.addTarget(self, action: #selector(popToArea), for: .touchUpInside)
        self.navItem.leftBarButtonItem = UIBarButtonItem.init(customView: areBtn)
        
        pickerView = AreaPickerView.init(frame: CGRect(x: 0, y: UIScreen.main.bounds.height - pickerH - 49, width: UIScreen.main.bounds.width, height: 220))
        self.view.addSubview(pickerView)
        pickerView.selectValue()
        pickerView.isHidden = true
    }
    
    func popToArea(){

        pickerView.isHidden = false
    }
    
    
    func requestData() {
        let areaDic = UserDefaults().getUserDefaults(key: SELECT_AREA_KEY) as? Dictionary<String, Any>
        let cityName = areaDic?["cityName"] as? String ?? "广州"
        print("cityName:\(cityName)")
        WBNetworkManager.shared.requestRepairList(city: cityName) { (arr, isSuccess) in
            var tempArr = arr
            for i in 0..<arr.count{
                var obj = tempArr[i]
                let coordinate = UserDefaults.init().getUserDefaults(key: LOCATION_KEY) as? [String:Double]
                let lat1 = obj["latitude"] as? Double ?? 0
                let lng1 = obj["longitude"] as? Double ?? 0
                let lat2 = coordinate?["latitude"]  ?? 0
                let lng2 = coordinate?["longitude"] ?? 0
                let str = Tool.getGreatCircleDistance(lat1, lng1: lng1, lat2: lat2, lng2: lng2)
                obj["distance"] = str as AnyObject
                tempArr[i] = obj
            }
            tempArr.sort(by: { (obj1, obj2) -> Bool in
                let distance1 = obj1["distance"] as? String ?? "0"
                let distance2 = obj2["distance"] as? String ?? "0"
                return Double(distance1)! < Double(distance2)!
            })
            self.listArr = tempArr
            self.originArr = tempArr
            self.mTableView.reloadData()
            self.mTableView.mj_header.endRefreshing()
        }
    }
    
    func pushEdit() {
        let isHave = UserDefaults().getUserDefaults(key: MY_GARAGE_KEY) as? Bool
        if(isHave == true){
            let  VC = WBMyPublishViewController()
            VC.isFromRepair = true
            navigationController?.pushViewController(VC, animated: true)
        }else{
            navigationController?.pushViewController(RepairPublishViewController(), animated: true)
        }
    }
}

extension RepairViewController : UITableViewDelegate,UITableViewDataSource  {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArr.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = listArr[indexPath.row]
        let cellId = cellID;
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PepairCarCell
        cell.viewModal = item
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    
        let item = listArr[indexPath.row]
        navigationController?.pushViewController(RepairDetailViewController.init(item: item), animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isIphone5 {
            return 100
        }
        return 120
    }
    
}

extension RepairViewController : UISearchBarDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count == 0 {
            listArr = originArr
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
        WBNetworkManager.shared.requestRepairSearchList(searchkey: searchKey) { (arr, isSuccess) in
            self.listArr = arr
            self.mTableView.reloadData()
        }
    }
}
