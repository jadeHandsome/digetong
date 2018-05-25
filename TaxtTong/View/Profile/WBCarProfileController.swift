//
//  WBCarProfileController.swift
//  TaxtTong
//
//  Created by ling on 2017/7/12.
//  Copyright © 2017年 ling. All rights reserved.
//

import UIKit
import SVProgressHUD

class WBCarProfileController: WBBaseViewController,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var platenumberTxtField: UITextField!
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var linkPhoneTxtField: UITextField!
    @IBOutlet weak var credentialsButton: UIButton!
    
    var credentialsStr: String?
    
    typealias carUserInfo = ([String: AnyObject]) ->()
    var getCarUserInfo: carUserInfo?
    var receiveCarUserInfo = [String:AnyObject]()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        renderUI()
    }


    
    @IBAction func clickCredentials(_ sender: UIButton) {
        
        self.present(sheet, animated: true, completion: nil)
    }

    @IBAction func clickSure(_ sender: UIButton) {
        
        var info = [String: AnyObject]()
        info["platenumber"] = platenumberTxtField.text as AnyObject
        info["linkphone"] = linkPhoneTxtField.text as AnyObject
        info["name"] = nameTxtField.text as AnyObject
        info["credentials"] =  credentialsButton.imageView?.image
        
        getCarUserInfo!(info)
        
        navigationController?.popViewController(animated: true)
    
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        self.dismiss(animated: true, completion: nil)
        
        let originImg = info[UIImagePickerControllerOriginalImage] as! UIImage
        credentialsButton.setImage(originImg, for: .normal)
        
        
    }
    
}


extension WBCarProfileController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    func renderUI() {
        
        title = "我的资料"
        
//        print(receiveCarUserInfo)
//        
//        platenumberTxtField.text = receiveCarUserInfo["platenumber"] as? String ?? ""
//        nameTxtField.text = receiveCarUserInfo["name"] as? String ?? ""
//        linkPhoneTxtField.text = receiveCarUserInfo["linkphone"] as? String ?? ""
//        credentialsButton.setImage(receiveCarUserInfo["credentials"] as? UIImage, for: .normal)
        
        let platenumber = receiveCarUserInfo["platenumber"] as? String ?? ""
        if platenumber != NULL {
            platenumberTxtField.text = platenumber
        }
        
        let name = receiveCarUserInfo["name"] as? String ?? ""
        if name != NULL {
            nameTxtField.text = name
        }
        
        let linkphone = receiveCarUserInfo["linkphone"] as? String ?? ""
        if linkphone != NULL {
            linkPhoneTxtField.text = linkphone
        }
        
        print(receiveCarUserInfo)
        let credentials = receiveCarUserInfo["credentials"] as? String ?? ""
        if credentials != NULL {
            credentialsButton.sd_setImage(with: URL.init(string: credentials), for: .normal)
        }
        
        
        
    }
}
