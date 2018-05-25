//
//  RegisterViewController.swift
//  TaxtTong
//
//  Created by ling on 2017/7/2.
//  Copyright © 2017年 ling. All rights reserved.
//

import UIKit

enum WBRegisterType{
    case Register
    case ForgetPwd
}

class RegisterViewController: WBBaseViewController {
    
    @IBOutlet weak var yzmBtn: UIButton!
    @IBOutlet weak var resgiterBtn: UIButton!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var yzmTextField: UITextField!
    @IBOutlet weak var rePwdTextField: UITextField!
    @IBOutlet weak var pwdTextFiled: UITextField!
    @IBOutlet weak var allowButton: UIButton!
    
    var type: WBRegisterType = WBRegisterType.Register
    lazy var loginViewModel = WBLoginViewModal()
    
    //nib创建的类扩展init只能便利构造函数
    convenience init(type: WBRegisterType){
        self.init(nibName: "RegisterViewController", bundle: nil)
        self.type = type
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //1.渲染UI
        renderUI()
        
    }


}

extension RegisterViewController {
    
    func renderUI() {
        
        title = type == WBRegisterType.Register ? "用户注册" : "修改密码"
        resgiterBtn.setTitle(type == WBRegisterType.Register ? "用户注册" : "修改密码", for: .normal)
        
        yzmBtn.layer.cornerRadius = 15;
        yzmBtn.layer.masksToBounds = true;
        yzmBtn.layer.borderWidth = 1
        yzmBtn.layer.borderColor = UIColor().getMainColor().cgColor
        
    }
    
    @IBAction func clickAllowBtn(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func clickYzmButton(_ sender: UIButton) {
        
        self.loginViewModel.getYzm(phone: phoneTextField.text!, completion: { (isSuccess) in
            Tool.countDown(sender)
        })
    }
    
    @IBAction func clickSureButton(_ sender: UIButton) {
        
        let phone = phoneTextField.text ?? ""
        let pwd = pwdTextFiled.text ?? ""
        let rpwd = rePwdTextField.text ?? ""
        let yzm = yzmTextField.text ?? ""
        let isAllow = !allowButton.isSelected
        if type == WBRegisterType.Register {
            self.loginViewModel.register(phone: phone, pwd: pwd, rpwd: rpwd, yzm: yzm, isAllow: isAllow, completion: { (isSuccess) in
                self.navigationController?.popViewController(animated: true)
            })
        }else{
            self.loginViewModel.forgetPwd(phone: phone, pwd: pwd, rpwd: rpwd, yzm: yzm, isAllow: isAllow, completion: { (isSuccess) in
                self.navigationController?.popViewController(animated: true)
            })
        }
        NotificationCenter().post(name: SEND_PHONE_NOTIF, dict: ["phone": phone])
        
    }
}
