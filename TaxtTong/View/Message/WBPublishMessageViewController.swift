//
//  WBPublishMessageViewController.swift
//  TaxtTong
//
//  Created by ling on 2017/7/26.
//  Copyright © 2017年 ling. All rights reserved.
//

import UIKit
import SVProgressHUD

class WBPublishMessageViewController: WBBaseViewController,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var typeButton: UIButton!
    @IBOutlet weak var titleTxtField: UITextField!
    @IBOutlet weak var contactPhoneTxtField: UITextField!
    @IBOutlet weak var contactPersonTxtField: UITextField!
    @IBOutlet weak var addressTxtView: UITextView!
    @IBOutlet weak var contentTxtView: UITextView!
    @IBOutlet weak var picButton: UIButton!
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var pickerConstraintBottom: NSLayoutConstraint!
    
    @IBOutlet weak var sureView: UIView!
    @IBOutlet weak var editView: UIView!
    
    let item: [String] = ["求购出租车","转让出租车","招聘司机","司机求职","司机代班"]
    
    var dataInfo: [String: AnyObject]?
    convenience init(dataInfo: [String: AnyObject]){
        self.init(nibName: "WBPublishMessageViewController", bundle: nil)
        self.dataInfo = dataInfo
        
    }
    
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

        title = "发布需求信息"

        if dataInfo != nil {
            if let type = dataInfo?["type"] as? Int {
                typeButton.setTitle(item[type-1], for: .normal)
            }
            if let img = dataInfo?["img"] as? String {
                picButton.sd_setImage(with: URL.init(string: img), for: .normal)
            }
            titleTxtField.text = dataInfo?["title"] as? String
            contactPhoneTxtField.text = dataInfo?["contactPhone"] as? String
            contactPersonTxtField.text = dataInfo?["contactPerson"] as? String
            addressTxtView.text = dataInfo?["address"] as? String
            contentTxtView.text = dataInfo?["content"] as? String
            contentTxtView = Tool.contentSize(toFit: contentTxtView)
            addressTxtView = Tool.contentSize(toFit: addressTxtView)
            
            sureView.isHidden = true
            editView.isHidden = false
        }
    }

    @IBAction func clickType(_ sender: UIButton) {
        pickerConstraintBottom.constant = pickerConstraintBottom.constant == -250 ? 0 : -250
    }


    @IBAction func clickPic(_ sender: UIButton) {
        
        self.present(sheet, animated: true, completion: nil)
    }
    
    @IBAction func clickSure(_ sender: UIButton) {
        
        SVProgressHUD.show()
        
        let title = titleTxtField.text
        let contactPhone = contactPhoneTxtField.text
        let contactPerson = contactPersonTxtField.text
        let address = addressTxtView.text
        let content = contentTxtView.text
        let typeStr = typeButton.titleLabel?.text
        var type = 1
        
        for i in 0..<item.count {
            if item[i] == typeStr {
                type = i + 1
                break
            }
        }
        
        let isExit: Bool = title == "" || contactPhone == "" || contactPerson == "" || address == "" || content == ""
        
        if isExit {
            SVProgressHUD.showError(withStatus: "信息不能为空")
            return
        }
        
        let areaDic = UserDefaults().getUserDefaults(key: SELECT_AREA_KEY) as? Dictionary<String, Any>
        let cityName = areaDic?["cityName"] as? String ?? "广州"
        
        var paramers = [String: AnyObject]()
        paramers["uid"] = WBUserinfoManager.shared.getUserInfoModal().uid as AnyObject
        paramers["sec"] = WBUserinfoManager.shared.getUserInfoModal().sec as AnyObject
        paramers["phone"] = WBUserinfoManager.shared.getUserInfoModal().phone as AnyObject
        paramers["city"] = cityName as AnyObject
        paramers["contactPhone"] = contactPhone as AnyObject
        paramers["contactPerson"] = contactPerson as AnyObject
        paramers["title"] = title as AnyObject
        paramers["content"] = content as AnyObject
        paramers["address"] = address as AnyObject
        paramers["type"] = type as AnyObject
        paramers["img"] = " " as AnyObject
        
        var isEdit = false
        if self.dataInfo != nil {
            paramers["state"] = 1 as AnyObject
            paramers["did"] = self.dataInfo?["did"] as AnyObject
            isEdit = true
        }
        
        if ((picButton.imageView?.image) != nil) {
            Tool.upyunLoadImg(picButton.imageView?.image) { (str) in
                
                if str?.characters.count == 0{
                    SVProgressHUD.dismiss()
                    SVProgressHUD.showError(withStatus: "发布失败")
                    return
                }
                
                let img = upyunDomin + str!
                paramers["img"] = img as AnyObject
                
                WBNetworkManager.shared.requestPublishNeeds(parameters: paramers,isEdit: isEdit, completion: { (isSuccess) in
                    if(isSuccess){
                        SVProgressHUD.showSuccess(withStatus: "发布成功,待审核通过后才可显示")
                        self.navigationController?.popViewController(animated: true)
                    }else{
                        SVProgressHUD.showError(withStatus: "发布失败")
                    }
                })
            }
        }else{
            WBNetworkManager.shared.requestPublishNeeds(parameters: paramers,isEdit: isEdit, completion: { (isSuccess) in
                if(isSuccess){
                    SVProgressHUD.showSuccess(withStatus: "发布成功,待审核通过后才可显示")
                    self.navigationController?.popViewController(animated: true)
                }else{
                    SVProgressHUD.showError(withStatus: "发布失败")
                }
            })
            
        }
        
    }
    

    
    @IBAction func clickCancel(_ sender: UIButton) {
        
    
        if let did = dataInfo?["did"] as? Int {
            WBNetworkManager.shared.requestDeleteMyNeeds(did: did, completion: { (isSuccess) in
                if isSuccess {
                    self.navigationController?.popViewController(animated: true)
                    SVProgressHUD.showSuccess(withStatus: "删除成功")
                }else{
                    SVProgressHUD.showError(withStatus: "删除失败")
                }
            })
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        self.dismiss(animated: true, completion: nil)
        let img = info[UIImagePickerControllerOriginalImage] as! UIImage
        picButton.setImage(img, for: .normal)
        
    }
}

extension WBPublishMessageViewController: UIPickerViewDelegate,UIPickerViewDataSource,UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return item.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return item[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        typeButton.setTitle(item[row], for: .normal)
    }
    
}
