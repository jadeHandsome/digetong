class BaiduNavViewController: UIViewController, BNNaviUIManagerDelegate,BNNaviRoutePlanDelegate{
    
    var Begin_longitude:Double=0.0  //初始点X 经度
    var Begin_latitude:Double=0.0   //初始点Y 纬度
    
    var End_longitude:Double=0.0  //终点X 经度
    var End_latitude:Double=0.0   //终点Y 纬度
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkServicesInited(longitude: Begin_longitude,latitude: Begin_latitude,CurrentaddressX: End_longitude,CurrentaddressY: End_latitude)
        
    }
    
    //检查引擎是否初始化完成
    func checkServicesInited(longitude:Double ,latitude:Double ,CurrentaddressX:Double ,CurrentaddressY:Double){
        let services = BNCoreServices.getInstance()!
        if services.isServicesInited() {
            startNav(longitude: longitude,latitude: latitude,CurrentaddressX: CurrentaddressX,CurrentaddressY: CurrentaddressY)
        }else{
            print("引擎尚未初始化完成，稍后再试")
        }
    }
    
    //启动导航
    func startNav(longitude:Double ,latitude:Double,CurrentaddressX:Double ,CurrentaddressY:Double ){
        let nodesArray:NSMutableArray =  NSMutableArray(capacity: 2)
        //起点 传入的是原始的经纬度坐标，若使用的是百度地图坐标，可以使用BNTools类进行坐标转化
        let startNode:BNRoutePlanNode = BNRoutePlanNode()
        startNode.pos = BNPosition()
        //这里获取到当前的位置的经度纬度就可以了
        startNode.pos.x = longitude//经度
        startNode.pos.y = latitude   //纬度
        startNode.pos.eType = BNCoordinate_OriginalGPS
        nodesArray.add(startNode)
        //终点
        let  endNode:BNRoutePlanNode = BNRoutePlanNode()
        endNode.pos = BNPosition()
        endNode.pos.x = CurrentaddressX //经度
        endNode.pos.y = CurrentaddressY  //纬度
        endNode.pos.eType = BNCoordinate_OriginalGPS
        nodesArray.add(endNode)
        
        var GONav = BNCoreServices.routePlanService()
        GONav?.startNaviRoutePlan(BNRoutePlanMode_Recommend, naviNodes: nodesArray as [AnyObject], time: nil, delegete: self, userInfo: nil)
    }
    
    //算路回调成功
    func routePlanDidFinished(userInfo: [NSObject : AnyObject]!) {
        //路径规划成功，开始导航
        let uiservice =  BNCoreServices.uiService()
        uiservice?.showPage(BNaviUI_NormalNavi, delegate: self, extParams: nil)
    }
    
    //算路回调失败
    func routePlanDidFailedWithError(error: NSError!, andUserInfo userInfo: [NSObject : AnyObject]!) {

        let code = error.code%10000
        switch (code)
        {
        case 5200:
            print("暂时无法获取您的位置,请稍后重试")
        case 5050:
            print("无法发起导航")
        case 5201:
            print("定位服务未开启,请到系统设置中打开定位服务。")
        case 5002:
            print("起终点距离起终点太近")
        default:
            print("算路失败")
            break;
        }
        
    }
    //算路取消回调
    func routePlanDidUserCanceled(userInfo: [NSObject : AnyObject]!) {
        
    }
    //退出导航
    func onExitNaviUI(extraInfo: [NSObject : AnyObject]!) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

