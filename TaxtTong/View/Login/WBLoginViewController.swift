//
//  WBLoginViewController.swift
//  TaxtTong
//
//  Created by ling on 2017/7/1.
//  Copyright © 2017年 ling. All rights reserved.
//

import UIKit

class WBLoginViewController: WBBaseViewController {

    internal lazy var loginViewModel = WBLoginViewModal()
    
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var phoneTxtField: UITextField!
    @IBOutlet weak var pwdTxtFiled: UITextField!
    @IBOutlet weak var selectBtn: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        NotificationCenter().addObserve(target: self, selector: #selector(receiveNotif(notification:)), name: SEND_PHONE_NOTIF)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        renderUI()
        
    }
    
    func receiveNotif(notification: Notification) {
        let userInfo = notification.userInfo
        let phone = userInfo?["phone"] as? String ?? "0"
        phoneTxtField.text = phone
    }
    
}

//UI
extension WBLoginViewController {
    
     func renderUI() {
        title = "用户登录";
        
        //设置手机号码初始值
        let loginInfo = WBLoginManager.shared.getLoginInfoModal()
        if loginInfo.isSave {
            phoneTxtField.text = loginInfo.phone
            if let himg = loginInfo.himg {
                if let url = URL.init(string: himg){
                    headImageView.setImageWith(url)
                }
            }
        }
    }
}

//按钮
extension WBLoginViewController {
    
    @IBAction func clickSelectBtn(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
    }
    
    @IBAction func pressLgin(_ sender: UIButton) {
        
        let phone = phoneTxtField.text ?? ""
        let pwd = pwdTxtFiled.text ?? ""
        self.loginViewModel.login(phone: phone, pwd: pwd, isSave: !selectBtn.isSelected) { (isSuccess) in
            print("登录成功")
            let loginInfo = WBLoginManager.shared.getLoginInfoModal()
            loginInfo.isSave = !self.selectBtn.isSelected
            WBLoginManager.shared.saveLoginInfoModal(loginInfo: loginInfo)
            if(self .isKind(of: WBNavigatorController.self)){
                self.navigationController?.pushViewController(WBMainViewController(), animated: true)
            }else{
                self.present(WBNavigatorController(rootViewController: WBMainViewController()), animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func pressRegister(_ sender:
        UIButton) {
        
        let registerVC = RegisterViewController.init(type: WBRegisterType.Register)
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    @IBAction func pressReloadPwd(_ sender: UIButton) {
        
        let registerVC = RegisterViewController.init(type: WBRegisterType.ForgetPwd)
        navigationController?.pushViewController(registerVC, animated: true)
    }
}
