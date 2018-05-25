//
//  WBMyPublishViewController.swift
//  TaxtTong
//
//  Created by ling on 2017/7/15.
//  Copyright © 2017年 ling. All rights reserved.
//

import UIKit
import SVProgressHUD

class WBMyPublishViewController: WBBaseViewController,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate  {
    
    @IBOutlet weak var scrollViewWConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mTableView: UITableView!
    @IBOutlet weak var superScrollView: UIScrollView!
    
    @IBOutlet weak var leftTabButton: UIButton!
    @IBOutlet weak var rightTabButton: UIButton!
    
    
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var linkPhoneTxtField: UITextField!
    @IBOutlet weak var personTxtField: UITextField!
    @IBOutlet weak var addressTxtView: UITextView!
    @IBOutlet weak var descritionTxtView: UITextView!
    @IBOutlet weak var credentialsButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var credentials: String?
    var gid: Int = 0
    var isFromRepair = false
    
    var listArr = [[String: AnyObject]]()
    
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
        renderUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

    @IBAction func clickTabButton(_ sender: UIButton) {
        
        if sender.tag == 1 && gid == 0{
        
            UIAlertController.init().share(target: self, msg: "您还没发布修配信息，是否前往查看", completion: {
//                self.tabBarController?.selectedIndex = 4
                self.navigationController?.pushViewController(RepairPublishViewController(), animated: true)
            })
            
            return
        }

        let lPosition = CGPoint(x: 0, y: 0)
        let rPosition = CGPoint(x: UIScreen().get_ScreenWidth(), y: 0)
        superScrollView.setContentOffset(sender.tag == 1 ? rPosition : lPosition, animated: true)
        
        if sender.tag == 1 {
            leftTabButton.setTitleColor(UIColor.black, for: .normal)
            rightTabButton.setTitleColor(UIColor().getMainColor(), for: .normal)
        }else{
            leftTabButton.setTitleColor(UIColor().getMainColor(), for: .normal)
            rightTabButton.setTitleColor(UIColor.black, for: .normal)
        }
    }
    
    @IBAction func pressEdit(_ sender: UIButton) {
        
        SVProgressHUD.show()
        let name = nameTxtField.text
        let phone = linkPhoneTxtField.text
        let contactPerson = self.personTxtField.text
        let address = addressTxtView.text
        let description = descritionTxtView.text
        
        let isExit: Bool = name == nil || phone == nil || contactPerson == nil || address == nil || description == nil || credentialsButton.imageView?.image == nil
        
        if isExit {
            SVProgressHUD.showError(withStatus: "信息不能为空")
            return
        }
        
        
        Tool.upyunLoadImg(credentialsButton.imageView?.image) { (str) in
            
            if str?.characters.count == 0{
                SVProgressHUD.dismiss()
                return
            }
            
            let credentials = upyunDomin + str!
            
            let areaDic = UserDefaults().getUserDefaults(key: SELECT_AREA_KEY) as? Dictionary<String, Any>
            let cityName = areaDic?["cityName"] as? String ?? "广州"
            
            var paramers = [String: AnyObject]()
            paramers["uid"] = WBUserinfoManager.shared.getUserInfoModal().uid as AnyObject
            paramers["sec"] = WBUserinfoManager.shared.getUserInfoModal().sec as AnyObject
            paramers["gid"] = self.gid as AnyObject
            paramers["city"] = cityName as AnyObject
            paramers["name"] = name as AnyObject
            paramers["phone"] = phone as AnyObject
            paramers["contactPerson"] = contactPerson as AnyObject
            paramers["description"] = description as AnyObject
            paramers["address"] = address as AnyObject
            paramers["img"] = credentials as AnyObject
            
            WBNetworkManager.shared.requestAddressCode(address: address!, completion: { (dic) in
                
                paramers["longitude"] = dic["lng"] as AnyObject
                paramers["latitude"] = dic["lat"] as AnyObject
                
                WBNetworkManager.shared.requestEditMyGarage(parameters: paramers, completion: { (isSuccess) in
                    if(isSuccess){
                        SVProgressHUD.showSuccess(withStatus: "修改成功")
                    }else{
                        SVProgressHUD.showSuccess(withStatus: "修改失败")
                    }
                })
            })
            
            
            SVProgressHUD.dismiss()
        }
    }
    
    
    @IBAction func pressDelete(_ sender: UIButton) {
        
        if gid != 0{
            
            WBNetworkManager.shared.requestDeleteMyGarage(gid: gid, completion: { (isSuccess) in
                if(isSuccess){
                    self.navigationController?.popViewController(animated: true)
                    SVProgressHUD.showSuccess(withStatus: "删除成功")
                    WBNetworkManager.shared.requestMyGarage { (dic) in
                        var isHave = false
                        if (dic["gid"] as? Int) != nil {
                            isHave = true
                        }
                        UserDefaults().saveUserDefaults(key: MY_GARAGE_KEY, value: isHave)
                    }
                }else{
                    SVProgressHUD.showSuccess(withStatus: "删除失败")
                }
            })
        }
    }
    
    
    @IBAction func clickCredentialsImg(_ sender: UIButton) {
        
        self.present(sheet, animated: true, completion: nil)
    }
    
    //相册代理
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        self.dismiss(animated: true, completion: nil)
        let img = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.credentialsButton.setImage(img, for: .normal)
        
    }
}

extension WBMyPublishViewController {
    
    func renderUI() {
        
        scrollViewWConstraint.constant = UIScreen().get_ScreenWidth() * 2
        superScrollView.isScrollEnabled = false
        
        editButton = UIButton().makeRadius(target: editButton, borderRadius: 5, backgroudColor: UIColor().getMainColor(), text: "修改")
        deleteButton = UIButton().makeRadius(target: deleteButton, borderRadius: 5, backgroudColor: UIColor().rgbaColorFromHex(rgb: 0x137ba8), text: "删除")
        
        mTableView.tableFooterView = UIView.init(frame: CGRect.zero)
        
        leftTabButton.setTitleColor(UIColor().getMainColor(), for: .normal)
        
        //请求我发布的汽车需求消息
        WBNetworkManager.shared.requestMyPublish { (arr) in
            self.listArr = arr
            self.mTableView?.reloadData()
        }
        
        //请求我发布的修理配修消息
        WBNetworkManager.shared.requestMyGarage { (dic) in
            
            self.nameTxtField.text = dic["name"] as? String ?? ""
            self.linkPhoneTxtField.text = dic["phone"] as? String ?? ""
            self.personTxtField.text = dic["contactPerson"] as? String ?? ""
            self.addressTxtView.text = dic["address"] as? String ?? ""
            self.descritionTxtView.text = dic["description"] as? String ?? ""
            self.gid = dic["gid"] as? Int ?? 0
            if let cre = dic["img"] as? String {
                self.credentialsButton.sd_setImage(with: URL.init(string: cre), for: .normal)
                self.credentials = cre
            }
            //存储gid
            let userInfo = WBUserinfoManager.shared.getUserInfoModal()
            userInfo.gid = self.gid
            WBUserinfoManager.shared.saveUserInfoModal(userInfo: userInfo)

            self.descritionTxtView = Tool.contentSize(toFit: self.descritionTxtView)
            self.addressTxtView = Tool.contentSize(toFit: self.addressTxtView)
            
            if (self.isFromRepair == true) {
                let btn = UIButton.init()
                btn.tag = 1
                self.clickTabButton(btn)
            }
        }
    }
}


extension WBMyPublishViewController : UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate {
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArr.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = listArr[indexPath.row]
        let cellId = "WBMyPublishViewController";
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: cellId)
        cell.textLabel?.text = item["title"] as? String ?? ""
        if let utime = item["utime"] as? Int  {
            cell.detailTextLabel?.text = Tool.transFormatData(utime)
        }
        cell.detailTextLabel?.textColor = UIColor().rgbaColorFromHex(rgb: 0xcfcfcf)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = listArr[indexPath.row]
        navigationController?.pushViewController(WBPublishMessageViewController.init(dataInfo: item), animated: true)
        
    }
    
    
}
