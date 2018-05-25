//
//  WBProfileDetailController.swift
//  TaxtTong
//
//  Created by ling on 2017/7/11.
//  Copyright © 2017年 ling. All rights reserved.
//

import UIKit
import SVProgressHUD

class WBProfileDetailController: WBBaseViewController,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var headImgButton: UIButton!
    @IBOutlet weak var nickNameTxtField: UITextField!
    @IBOutlet weak var platenumberButton: UIButton!
    @IBOutlet weak var nameButton: UIButton!
    @IBOutlet weak var linkPhoneButton: UIButton!
    @IBOutlet weak var credentialsButton: UIButton!
    @IBOutlet weak var sureButton: UIButton!
    
    var isUpdateMsg = false
    var isAddCompany = false
    var tid: Int!
    var credentials = ""
    
    lazy var sheet: UIAlertController = {
        
        var sheet =  UIAlertController.init(title: "请选择照片", message: nil, preferredStyle: .actionSheet)
        
        let ipc = UIImagePickerController()
        ipc.delegate = self
        ipc.allowsEditing = true
        
        
        let actionPhoto = UIAlertAction.init(title: "相册", style: .destructive, handler: { (action) in
            if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary){ return }
            ipc.sourceType = .photoLibrary
            self.present(ipc, animated: true, completion: nil)
        })
        let actionCamera = UIAlertAction.init(title: "相机", style: .default, handler: { (action) in
            if !UIImagePickerController.isSourceTypeAvailable(.camera){ return }
            ipc.sourceType = .camera
            self.present(ipc, animated: true, completion: nil)
        })
        let actionCancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        
        sheet.addAction(actionPhoto)
        sheet.addAction(actionCamera)
        sheet.addAction(actionCancel)

        
        return sheet
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if(isAddCompany){
            sureButton.setTitle("加入公司", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        renderUI()
    }

    //点击头像
    @IBAction func clickHeadImg(_ sender: UIButton) {
        
        self.present(sheet, animated: true, completion: nil)
    }

    
    
    //确定修改
    @IBAction func clickSure(_ sender: UIButton) {
        
        SVProgressHUD.show()
        
        let nickname = self.nickNameTxtField.text
        let linkphone = self.linkPhoneButton.titleLabel?.text
        let platenumber = self.platenumberButton.titleLabel?.text
        let name = self.nameButton.titleLabel?.text
        
        let isExit: Bool = nickname == nil || linkphone == nil || platenumber == nil || name == nil || credentialsButton.imageView?.image == nil
        
        if isExit {
            SVProgressHUD.showError(withStatus: "用户信息不能为空")
            return
        }
        
        let tid = WBUserinfoManager.shared.getUserInfoModal().tid
        if tid != NULL {
            WBNetworkManager.shared.requestExitCompany(completion: { (isSuccess) in
                if isSuccess {
                    JPUSHService.setTags(["00000"], completion: nil, seq: 0)
                    
                    let vc = WBAddCompanyController.init()
                    vc.title = "公司"
                    vc.tabBarItem.image = UIImage(named: "tabbar_gongsi")
                    vc.tabBarItem.selectedImage = UIImage(named: "tabbar_gongsi_highlighted")?.withRenderingMode(.alwaysOriginal)
                    vc.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor().getMainColor()], for: .highlighted)
                    let nav = WBNavigatorController(rootViewController: vc)
                    var vcArr = self.tabBarController?.viewControllers
                    vcArr?.replaceSubrange(Range(1..<2), with: [nav])
                    self.tabBarController?.setViewControllers(vcArr, animated: true)
                    
                    Tool.upyunLoadImg(self.credentialsButton.imageView?.image, imgStr: { (str) in
                        if str?.characters.count == 0{
                            SVProgressHUD.dismiss()
                            return
                        }
                        
                        self.credentials = upyunDomin + str!
                        
                        let areaDic = UserDefaults().getUserDefaults(key: SELECT_AREA_KEY) as? Dictionary<String, Any>
                        let cityName = areaDic?["cityName"] as? String ?? "广州"
                        
                        //加入公司
                        let userInfo = WBUserinfoManager.shared.userInfo
                        var addParamers = [String: AnyObject]();
                        addParamers["uid"] = userInfo.uid as AnyObject;
                        addParamers["sec"] = userInfo.sec as AnyObject
                        addParamers["city"] = cityName as AnyObject
                        addParamers["tid"] = tid as AnyObject
                        addParamers["credentials"] = self.credentials as AnyObject
                        addParamers["platenumber"] = platenumber as AnyObject
                        addParamers["linkphone"] = linkphone as AnyObject
                        addParamers["name"] = nickname as AnyObject
                        
                        print("addParamers:%@",addParamers)
                        
                        WBNetworkManager.shared.requestAddCompany(parameters: addParamers) { (code) in
                        }
                        
                        //更新个人信息
                        var paramers = [String: AnyObject]()
                        paramers["uid"] = userInfo.uid as AnyObject
                        paramers["sec"] = userInfo.sec as AnyObject
                        paramers["nickname"] = nickname as AnyObject
                        paramers["linkphone"] = linkphone as AnyObject
                        paramers["platenumber"] = platenumber as AnyObject
                        paramers["name"] = name as AnyObject
                        paramers["credentials"] = self.credentials as AnyObject
                        
                        WBNetworkManager.shared.setUserInfo(parameters: paramers) { (dic) in
                            
                            SVProgressHUD.dismiss()
                            if dic.count > 0 {
                                //更新用户信息
                                WBLoginViewModal.init().getUserInfo(completion: { (isSuccess) in
                                    if isSuccess { NotificationCenter().post(name: SEND_UPDATEINGO_NOTIF, dict: [:]) }
                                })
                                
                                SVProgressHUD.showSuccess(withStatus:  self.isAddCompany ? "申请成功" : "设置成功" )
                            }else{
                                SVProgressHUD.showSuccess(withStatus: self.isAddCompany ? "申请失败" : "设置失败")
                            }
                        }
                    })
                }else{
                    SVProgressHUD.dismiss()
                    SVProgressHUD.showError(withStatus: self.isAddCompany ? "申请失败" : "设置失败")
                }
            })
        }else{
            Tool.upyunLoadImg(self.credentialsButton.imageView?.image, imgStr: { (str) in
                if str?.characters.count == 0{
                    SVProgressHUD.dismiss()
                    return
                }
                
                self.credentials = upyunDomin + str!
                
                let areaDic = UserDefaults().getUserDefaults(key: SELECT_AREA_KEY) as? Dictionary<String, Any>
                let cityName = areaDic?["cityName"] as? String ?? "广州"
                
                //加入公司
                let userInfo = WBUserinfoManager.shared.userInfo
                var addParamers = [String: AnyObject]();
                addParamers["uid"] = userInfo.uid as AnyObject;
                addParamers["sec"] = userInfo.sec as AnyObject
                addParamers["city"] = cityName as AnyObject
                addParamers["tid"] = self.tid as AnyObject
                addParamers["credentials"] = self.credentials as AnyObject
                addParamers["platenumber"] = platenumber as AnyObject
                addParamers["linkphone"] = linkphone as AnyObject
                addParamers["name"] = nickname as AnyObject
                
                print("xx:",addParamers)
                
                WBNetworkManager.shared.requestAddCompany(parameters: addParamers) { (code) in
                }
                
                //更新个人信息
                var paramers = [String: AnyObject]()
                paramers["uid"] = userInfo.uid as AnyObject
                paramers["sec"] = userInfo.sec as AnyObject
                paramers["nickname"] = nickname as AnyObject
                paramers["linkphone"] = linkphone as AnyObject
                paramers["platenumber"] = platenumber as AnyObject
                paramers["name"] = name as AnyObject
                paramers["credentials"] = self.credentials as AnyObject
                
                WBNetworkManager.shared.setUserInfo(parameters: paramers) { (dic) in
                    
                    SVProgressHUD.dismiss()
                    if dic.count > 0 {
                        //更新用户信息
                        WBLoginViewModal.init().getUserInfo(completion: { (isSuccess) in
                            if isSuccess { NotificationCenter().post(name: SEND_UPDATEINGO_NOTIF, dict: [:]) }
                        })
                        
                        SVProgressHUD.showSuccess(withStatus: self.isAddCompany ? "申请成功" : "设置成功")
                    }else{
                        SVProgressHUD.showSuccess(withStatus: self.isAddCompany ? "申请失败" : "设置失败")
                    }
                }
            })
        }
    }
    
    //点击cell
    func clickCellBtn() {
        
        var info = [String: AnyObject]()
        info["linkphone"] = linkPhoneButton.titleLabel?.text as AnyObject
        info["platenumber"] = platenumberButton.titleLabel?.text as AnyObject
        info["name"] = nameButton.titleLabel?.text as AnyObject
        info["credentials"] = self.credentials as AnyObject
        
        let carProfileVC = WBCarProfileController()
        carProfileVC.receiveCarUserInfo = info
        
        weak var weakSelf = self
        carProfileVC.getCarUserInfo = { (carUserInfo) -> () in
            
            weakSelf?.platenumberButton.setTitle(carUserInfo["platenumber"] as? String ?? "", for: .normal)
            weakSelf?.nameButton.setTitle(carUserInfo["name"] as? String ?? "", for: .normal)
            weakSelf?.linkPhoneButton.setTitle(carUserInfo["linkphone"] as? String ?? "", for: .normal)
            let credentials = carUserInfo["credentials"]
            weakSelf?.credentialsButton.setImage(credentials as? UIImage, for: .normal)
            
            weakSelf?.isUpdateMsg = true
        }
        
        navigationController?.pushViewController(carProfileVC, animated: true)
    }
    
    
    //头像-相册代理
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        self.dismiss(animated: true, completion: nil)
        let img = info[UIImagePickerControllerOriginalImage] as! UIImage
        headImgButton.setImage(img, for: .normal)
        updaloadHeadImg()
        
    }
    
    
}


extension WBProfileDetailController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    func renderUI() {
        
        headImgButton.layer.cornerRadius = 32
        headImgButton.layer.masksToBounds = true
        
        for btn in [platenumberButton,nameButton,linkPhoneButton,credentialsButton] {
            btn?.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
            btn?.addTarget(self, action: #selector(clickCellBtn), for: .touchUpInside)
        }
        
        let himg = WBUserinfoManager.shared.userInfo.himg
        if himg != nil {
            headImgButton.sd_setImage(with: URL.init(string: himg!), for: .normal)
        }
        
        let nickName = WBUserinfoManager.shared.userInfo.nickname
        if nickName != nil {
            nickNameTxtField.text = nickName
        }
        
        let platenumber = WBUserinfoManager.shared.userInfo.platenumber
        if platenumber != nil {
            platenumberButton.setTitle(platenumber, for: .normal)
        }

        let name = WBUserinfoManager.shared.userInfo.name
        if platenumber != nil {
            nameButton.setTitle(name, for: .normal)
        }
        
        let linkphone = WBUserinfoManager.shared.userInfo.linkphone
        if linkphone != nil {
            linkPhoneButton.setTitle(linkphone, for: .normal)
        }
        
        self.credentials = WBUserinfoManager.shared.userInfo.credentials ?? ""
        if self.credentials != nil {
           credentialsButton.sd_setImage(with: URL.init(string: credentials), for: .normal)
        }
        
    }
    
    
    func updaloadHeadImg() {
        SVProgressHUD.show()
        Tool.upyunLoadImg(headImgButton.imageView?.image) { (str) in
            
            if str?.characters.count == 0{
                SVProgressHUD.dismiss()
                return
            }
            
            let imgStr = upyunDomin + str!
            
            WBNetworkManager.shared.setHeadImg(imgStr: imgStr, completion: { (dic) in
                
                SVProgressHUD.dismiss()
                if dic.count > 0 {
                    SVProgressHUD.showSuccess(withStatus: "设置头像成功")
                    let userInfo = WBUserinfoManager.shared.getUserInfoModal()
                    userInfo.himg = imgStr
                    WBUserinfoManager.shared.saveUserInfoModal(userInfo: userInfo)
                    NotificationCenter().post(name: SEND_UPDATEINGO_NOTIF, dict: [:])
                }else{
                    SVProgressHUD.showError(withStatus: "设置头像失败")
                }

            })
        }
    }
    
}
