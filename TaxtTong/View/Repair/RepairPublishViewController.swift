//
//  RepairPublishViewController.swift
//  TaxtTong
//
//  Created by ling on 2017/7/31.
//  Copyright © 2017年 ling. All rights reserved.
//

import UIKit
import SVProgressHUD

class RepairPublishViewController: WBBaseViewController,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate {

    @IBOutlet weak var nameTxtFiled: UITextField!
    @IBOutlet weak var phoneTxtField: UITextField!
    @IBOutlet weak var contactPersonTxtField: UITextField!
    @IBOutlet weak var addressTxtView: UITextView!
    @IBOutlet weak var descriptionTxtView: UITextView!
    @IBOutlet weak var certificateBtn: UIButton!
    
    
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
        initLocation()
    }
    

    @IBAction func clickCertificate(_ sender: UIButton) {
        
        self.present(sheet, animated: true, completion: nil)
    }
    
    @IBAction func clickSure(_ sender: UIButton) {
        
        SVProgressHUD.show()
        
        let name = nameTxtFiled.text
        let phone = phoneTxtField.text
        let contactPerson = contactPersonTxtField.text
        let address = addressTxtView.text
        let description = descriptionTxtView.text

        
        let isExit: Bool = name == nil || contactPerson == nil || phone == nil || address == nil || description == nil || certificateBtn.imageView?.image == nil
        
        if isExit {
            SVProgressHUD.showError(withStatus: "信息不能为空")
            return
        }
        
        
        Tool.upyunLoadImg(certificateBtn.imageView?.image) { (str) in
            
            if str?.characters.count == 0{
                SVProgressHUD.dismiss()
                return
            }
            
            let areaDic = UserDefaults().getUserDefaults(key: SELECT_AREA_KEY) as? Dictionary<String, Any>
            let cityName = areaDic?["cityName"] as? String ?? "广州"
            
            let img = upyunDomin + str!
            
            var paramers = [String: AnyObject]()
            
            WBNetworkManager.shared.requestAddressCode(address: address!, completion: { (dic) in
                
                paramers["longitude"] = dic["lng"] as AnyObject
                paramers["latitude"] = dic["lat"] as AnyObject
                
                paramers["uid"] = WBUserinfoManager.shared.getUserInfoModal().uid as AnyObject
                paramers["sec"] = WBUserinfoManager.shared.getUserInfoModal().sec as AnyObject
                paramers["city"] = cityName as AnyObject
                paramers["phone"] = phone as AnyObject
                paramers["contactPerson"] = contactPerson as AnyObject
                paramers["name"] = name as AnyObject
                paramers["description"] = description as AnyObject
                paramers["address"] = address as AnyObject
                paramers["img"] = img as AnyObject
                
                print("paramers:",paramers)
                
                WBNetworkManager.shared.requestPublishGarage(parameters: paramers, completion: { (isSuccess) in
                    if(isSuccess){
                        SVProgressHUD.showSuccess(withStatus: "发布成功")
                        self.navigationController?.popViewController(animated: true)
                        
                        WBNetworkManager.shared.requestMyGarage { (dic) in
                            var isHave = false
                            if (dic["gid"] as? Int) != nil {
                                isHave = true
                            }
                            UserDefaults().saveUserDefaults(key: MY_GARAGE_KEY, value: isHave)
                        }
                        
                    }else{
                        SVProgressHUD.showError(withStatus: "发布失败")
                    }
                })
            })
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        self.dismiss(animated: true, completion: nil)
        let img = info[UIImagePickerControllerOriginalImage] as! UIImage
        certificateBtn.setImage(img, for: .normal)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
   

}

extension RepairPublishViewController:BMKLocationServiceDelegate {
    
    func renderUI() {
        title = "发布汽车修配信息"
    }
    
    func initLocation() {
        
        let locService = BMKLocationService.init()
        locService.delegate = self
        locService.startUserLocationService()
    }
    
    func didUpdate(_ userLocation: BMKUserLocation!) {
        
        print("lat:\(userLocation.location.coordinate.latitude) -- lng:\(userLocation.location.coordinate.longitude)")
    }
    
    
}
