//
//  WBWebViewController.swift
//  TaxtTong
//
//  Created by ling on 2017/7/8.
//  Copyright © 2017年 ling. All rights reserved.
//

import UIKit
import SVProgressHUD

class WBWebViewController: WBBaseViewController,UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    var hid: Int64 = 0
    
    convenience init(hid: Int64){
        self.init(nibName: "WBWebViewController", bundle: nil)
        self.hid = hid
    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        SVProgressHUD.show()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WBNetworkManager.shared.requestHtml(hid: String(hid)) { (text, isSuccess) in
            self.webView.loadHTMLString(text ?? "暂无内容", baseURL: nil)
        }
    }
    
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }

}
