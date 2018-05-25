//
//  AreaPickerView.swift
//  Demo
//
//  Created by ling on 2017/11/1.
//  Copyright © 2017年 ling. All rights reserved.
//

import UIKit

class AreaPickerView: UIView,UIPickerViewDelegate,UIPickerViewDataSource {
    
    var cityDic: Dictionary<String, Any>!
    var selectCountL = 0
    var selectCountR = 0
    var proName = ""
    var cityName = ""
    var pickerView: UIPickerView!
//    var superVC: WBBaseViewController?
    
    
     override init(frame: CGRect) {
        super.init(frame: frame)
        
        guard let jsonPath = Bundle.main.path(forResource: "Area.json", ofType: nil),
            let jsonData =  NSData(contentsOfFile: jsonPath),
            let obj = try!JSONSerialization.jsonObject(with: jsonData as Data, options: []) as? [String: Any],
            let areaArr = obj["data"] as? [NSDictionary]
            
            else { return  }
        
        
        var dic = [String: Array<String>]();
        for areaObj in areaArr {
            let proName = areaObj["name"] as! String
            let tempArr = areaObj["city"] as! [NSDictionary]
            var cityArr : [String] = [];
            for tempObj in tempArr {
                if let cityName = tempObj["name"] {
                    cityArr.append(cityName as! String)
                }
            }
            dic[proName] = cityArr
        }
        cityDic = dic
        
        self.backgroundColor = UIColor.white
        
        let pickerTopView = UIView.init(frame: CGRect(x: 0, y: 1, width: self.bounds.width, height: 40))
        pickerTopView.backgroundColor = UIColor(red: 24/255.0, green: 148/255.0, blue: 218/255.0, alpha: 1)
        self.addSubview(pickerTopView)
        
        let leftButton = UIButton.init(frame: CGRect(x: 20, y: 0, width: 60, height: pickerTopView.bounds.height))
        leftButton.setTitle("取消", for: .normal)
        leftButton.setTitleColor(UIColor.white, for: .normal)
        leftButton.addTarget(self, action: #selector(clickCancel), for: .touchUpInside)
        pickerTopView.addSubview(leftButton)
        
        let rightButton = UIButton.init(frame: CGRect(x: pickerTopView.bounds.width - 60, y: 0, width: 60, height: pickerTopView.bounds.height))
        rightButton.setTitle("选择", for: .normal)
        rightButton.setTitleColor(UIColor.white, for: .normal)
        rightButton.addTarget(self, action: #selector(clickSure), for: .touchUpInside)
        pickerTopView.addSubview(rightButton)
        
        pickerView = UIPickerView.init(frame: CGRect(x: 0, y: 40, width: self.bounds.width, height: pickerH-40))
        pickerView.delegate = self as UIPickerViewDelegate
        pickerView.dataSource = self as UIPickerViewDataSource
        self.addSubview(pickerView)
    }
    
    func selectValue(){
        
        let dic = UserDefaults().getUserDefaults(key: SELECT_AREA_KEY) as? Dictionary<String, Any>
        var row1 = dic?["row1"] as? Int ?? 999
        var row2 = dic?["row2"] as? Int ?? 999
        
        if(row1 == 999){
            row1 = 4
            row2 = 0
        }
        
        pickerView.selectRow(row1, inComponent: 0, animated: false)
        pickerView.selectRow(row2, inComponent: 1, animated: false)
        self.selectCountL = row1
        self.selectCountR = row2
        pickerView.reloadAllComponents()
        
        let keys = Array(cityDic.keys);
        proName = keys[selectCountL]
        let cityArr = cityDic[proName] as! NSArray
        cityName = cityArr[row2] as! String
        

    }
    
    func clickSure(){
        let dic = ["row1": selectCountL, "row2": selectCountR, "proName": proName, "cityName": cityName] as [String : Any]
        UserDefaults().saveUserDefaults(key: SELECT_AREA_KEY, value: dic)
        
        NotificationCenter().post(name: SELECT_AREA_KEY, dict: [:])
        
        clickCancel()
    }
    
    func clickCancel(){
        
        self.isHidden = true
    }
    
    func popToArea() {
        
        selectValue()
        self.isHidden = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let keys = Array(cityDic.keys);
        if component == 0 {
            return keys.count
        }else{
            let pro = keys[selectCountL]
            let citys = cityDic[pro] as! NSArray
            return citys.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        var title = ""
        let keys = Array(cityDic.keys);
        switch component {
        case 0:
            title = keys[row]
        case 1:
            let pro = keys[selectCountL]
            let citys = cityDic[pro] as! NSArray
            title = citys[row] as! String
        default:
            break
        }
        
        return title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let keys = Array(cityDic.keys);
        
        if component == 0 {
            selectCountL = row
            proName = keys[selectCountL]
        }else if(component == 1){
            selectCountR = row
            let cityArr = cityDic[proName] as! NSArray
            
            cityName = cityArr[row] as! String
            print("cityArr:\(cityName)")
        }
        pickerView.reloadComponent(1)
        
    }
}


