//
//  WBMessageViewController.swift
//  TaxtTong
//
//  Created by ling on 2017/7/1.
//  Copyright © 2017年 ling. All rights reserved.
//

import UIKit

class WBMessageViewController: WBBaseViewController {

    @IBOutlet weak var mTableView: UITableView!
    @IBOutlet var typeButtons: [UIButton]!
    
    let cellID = "WBMessageCell"
    var listArr = [[String: AnyObject]]()
    var lastSelectButton: UIButton!
    var type = 1
    var areBtn: UIButton!
    var pickerView: AreaPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        renderUI()
        
        //请求数据
        requestWithType()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter().addObserve(target: self, selector: #selector(receiveAreaNotif), name: SELECT_AREA_KEY)
    }
    
    func receiveAreaNotif() {
        let dic = UserDefaults().getUserDefaults(key: SELECT_AREA_KEY) as? Dictionary<String, Any>
        let title = dic?["cityName"] as? String ?? "广州"
        areBtn.setTitle(title, for: .normal)
        self.navItem.leftBarButtonItem = UIBarButtonItem.init(customView: areBtn)
        pickerView.selectValue()
        requestWithType()
    }
    

    @IBAction func clickType(_ sender: UIButton) {
        lastSelectButton?.isSelected = false
        sender.isSelected = true
        lastSelectButton = sender
        type = sender.tag + 1
        print(NSString(format: "点的tag --->  %d", sender.tag + 1))
        requestWithType()
    }
    
    func requestWithType() {
        let areaDic = UserDefaults().getUserDefaults(key: SELECT_AREA_KEY) as? Dictionary<String, Any>
        let cityName = areaDic?["cityName"] as? String ?? "广州"
        
        WBNetworkManager.shared.requestNeedsList(type: type, city: cityName) { ( arr, isSuccess ) in
            self.listArr = arr
            self.mTableView.reloadData()
        }
    }
    
}

extension WBMessageViewController {
    
    func renderUI() {
        
        lastSelectButton = typeButtons[0]
        lastSelectButton.isSelected = true
        
        mTableView?.tableFooterView = UIView.init(frame: CGRect.zero)
        mTableView?.register(UINib.init(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
        
        navItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "message_navitem_edit"), style: .plain, target: self, action: #selector(pushEdit))
        
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
    
    func pushEdit() {
        
        navigationController?.pushViewController(WBPublishMessageViewController(), animated: true)
    }
    
}

extension WBMessageViewController : UITableViewDelegate,UITableViewDataSource  {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listArr.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = listArr[indexPath.row]
        let cellId = cellID;
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! WBMessageCell
        cell.viewModal = item
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = listArr[indexPath.row]
        navigationController?.pushViewController(WBMessageDetailViewController.init(item: item), animated: true)
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
}
