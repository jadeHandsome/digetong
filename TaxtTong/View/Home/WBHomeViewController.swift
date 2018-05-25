//
//  WBHomeViewController.swift
//  TaxtTong
//
//  Created by ling on 2017/7/1.
//  Copyright © 2017年 ling. All rights reserved.
//

import UIKit
import SDCycleScrollView

class WBHomeViewController: WBBaseViewController,SDCycleScrollViewDelegate {

    var areaPickerView: AreaPickerView!
    
    @IBOutlet weak var mtableView: UITableView!
    
    var listArr = [[String: AnyObject]]()
    var areBtn: UIButton!
    var pickerView: AreaPickerView!
    var bannerArr = [[String: AnyObject]]();
    
    lazy var cycleScrollView = SDCycleScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //加载UI
        renderUI()
        
        //请求数据
        requestData()
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    
    func receiveAreaNotif() {
        
        let dic = UserDefaults().getUserDefaults(key: SELECT_AREA_KEY) as? Dictionary<String, Any>
        let title = dic?["cityName"] as? String ?? "广州"
        areBtn.setTitle(title, for: .normal)
        self.navItem.leftBarButtonItem = UIBarButtonItem.init(customView: areBtn)
        pickerView.selectValue()
    }

    
    //点击横幅
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        
        let item = self.bannerArr[index]
        let hid = item["hid"] as? Int64 ?? 0
        let webView = WBWebViewController(hid: hid)
        self.navigationController?.pushViewController(webView, animated: true)
    }
    
    
}

extension WBHomeViewController {
    
    func renderUI() {
        
        mtableView.register(UINib.init(nibName: "WBHomeCell", bundle: nil), forCellReuseIdentifier: "WBHomeCell")
        
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
        
        //请求banner数据
        WBNetworkManager.shared.requestAdBrannerList { (arr, isSuccess) in
            self.cycleScrollView = SDCycleScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen().get_ScreenWidth(), height: 210),
                                                delegate: self,
                                                placeholderImage: UIImage.init())
            var data = [String]();
            for item in arr {
                data.append(item["img"] as! String)
            }
            self.cycleScrollView.imageURLStringsGroup = data
            self.bannerArr = arr
            self.mtableView.reloadData()
        }
        
        
        
        //请求首页列表数据
        WBNetworkManager.shared.requestAdHomeList { (arr, isSuccess) in
            self.listArr = arr
            self.mtableView.reloadData()
        }
        
        WBLoginViewModal.init().getUserInfo { (isSuccess) in
            if isSuccess == false{
                WBLoginViewModal().logout();
                WBUserinfoManager.shared.removeUserInfoModal()
                self.view.window?.rootViewController = WBNavigatorController(rootViewController: WBLoginViewController())
            }
        }
        
        //请求我的汽修厂
        WBNetworkManager.shared.requestMyGarage { (dic) in
            var isHave = false
            if (dic["gid"] as? Int) != nil {
                isHave = true
            }
            UserDefaults().saveUserDefaults(key: MY_GARAGE_KEY, value: isHave)
        }
        
    }
    
}

extension WBHomeViewController: UITableViewDelegate,UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listArr.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = listArr[indexPath.row]
        let cellId = "WBHomeCell";
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! WBHomeCell
        cell.viewModal = item
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = listArr[indexPath.row]
        let hid = item["hid"] as? Int64 ?? 0
        let webView = WBWebViewController(hid: hid)
        navigationController?.pushViewController(webView, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.cycleScrollView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 210
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
}


