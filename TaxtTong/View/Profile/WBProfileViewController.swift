//
//  WBProfileViewController.swift
//  TaxtTong
//
//  Created by ling on 2017/7/1.
//  Copyright © 2017年 ling. All rights reserved.
//

import UIKit

class WBProfileViewController: WBBaseViewController {

    @IBOutlet weak var headImgButton: UIButton!
    @IBOutlet weak var mTableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    
    let listArr = ["我的资料","我的消息","我的收藏","我的发布","设置"]
    let cellId = "WBProfileCell";
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTable()
        
        renderUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter().addObserve(target: self, selector: #selector(receiveAddInfo(notification:)), name: SEND_UPDATEINGO_NOTIF)
        
        requestMessage()
    }
    
    func receiveAddInfo(notification: Notification) {
        renderTop()
    }
    
    @IBAction func clickHeadImg(_ sender: UIButton) {
        navigationController?.pushViewController(WBProfileDetailController(), animated: true)
    }
    


}

extension WBProfileViewController {
    
    func renderUI() {
        
        navItem.title = "个人中心"
        
        headImgButton.layer.cornerRadius = 32
        headImgButton.layer.masksToBounds = true
        
        renderTop()
        
    }
    
    func renderTop() {
        let urlStr = WBUserinfoManager.shared.userInfo.himg
        if urlStr != nil {
            headImgButton.sd_setImage(with: URL.init(string: urlStr!), for: .normal)
        }
        
        let nickName = WBUserinfoManager.shared.userInfo.nickname
        if nickName != NULL {
            nameLabel.text = nickName
        }
    }
    
    func requestMessage() {
        WBNetworkManager.shared.requestMyMessage { (arr) in
            
            self.count = 0
            for i in 0..<arr.count {
                let msgObj = arr[i]
                if(msgObj["state"] as? Int ?? 0 == 1){
                    self.count += 1;
                }
            }
            
            self.mTableView?.reloadData()
           
        }
    }
}

extension WBProfileViewController: UITableViewDelegate,UITableViewDataSource {
    
    func setupTable() {
        mTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = listArr[indexPath.row]
        
        if(indexPath.row == 1){
            let btn = UIButton.init(type: .custom)
            btn.frame = CGRect(x: UIScreen().get_ScreenWidth() - 60, y: 10, width: 22, height: 22)
            btn.layer.cornerRadius = 11
            btn.layer.masksToBounds = true
            btn.backgroundColor =  .red
            btn.setTitle(String(self.count), for: .normal)
            btn.setTitleColor(.white, for: .normal)
            cell.addSubview(btn)
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        var VC: UIViewController?
        switch indexPath.row {
        case 0:
            VC = WBProfileDetailController()
        case 1:
            VC = WBMyMessageController()
        case 2:
            VC = WBMyCollectViewController()
        case 3:
            VC = WBMyPublishViewController()
        case 4:
            VC = WBSettingViewController()
        default:
            break
        }
        navigationController?.pushViewController(VC!, animated: true)
    }
    
}
