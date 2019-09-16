
import UIKit
import Foundation
import AFNetworking
import Reachability
import SVProgressHUD

class NetworkRequest: NSObject {
    
    let BASEURL = "https://newsapi.org/v2/"
    let API_KEY = "0498b8b67f8b4dc69d8fb40fc0041df3"
    
    typealias CompleteBlock = (URLSessionDataTask?,Any) -> Void
    typealias ErrorBlock =  (URLSessionDataTask?, Error?) -> Void
    static let sharedInstance = NetworkRequest()
    private override init() {
        debugPrint("NetworkRequest Private Init")
    }
    
    func httpManagerGet(baseUrl: String) -> AFHTTPSessionManager
    {
        let httpManager = AFHTTPSessionManager(baseURL: URL(string: baseUrl))
        
        let requestSerializer : AFJSONRequestSerializer = AFJSONRequestSerializer()
        
        requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        
        if let token = (UserDefaults.standard.value(forKey: "token")) as? String, token.count>0
        {
            requestSerializer.setValue("Bearer "+"\(token)", forHTTPHeaderField: "Authorization")
        }
        
        httpManager.requestSerializer = requestSerializer
        httpManager.requestSerializer.timeoutInterval = 50.0
        return httpManager
        
    }
    
    
    func alertMsg(){
        
        let alert = UIAlertController(title: "Oops!", message: "Check Your Connection and Try Again", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }

    //MARK : GET Method
    func getDataFromWebAPIWithGet(showProgressHud: Bool = true, _ url: String, _ requestData: NSMutableDictionary, _ completeBlock: @escaping CompleteBlock, _ errorBlock: @escaping ErrorBlock)
    {
        let reach: Reachability
        do
        {
            reach = Reachability.forInternetConnection()
            if reach.isReachable()
            {
                if showProgressHud
                {
                    SVProgressHUD.show(withStatus: "Please wait...")
                }
                self.httpManagerGet(baseUrl: BASEURL).get(url, parameters: requestData, progress: nil, success: completeBlock, failure: errorBlock)
                
            }
            else
            {
                if showProgressHud
                {
                    SVProgressHUD.dismiss()
                }
                alertMsg()
            }
            
        }
        
    }
    
    func errorResponseForApi(error:Error?){
        do
        {
            if let errorData = (error!._userInfo![AFNetworkingOperationFailingURLResponseDataErrorKey] as? Data){
                
                if let responseObj = (try JSONSerialization.jsonObject(with: errorData, options: [])) as? NSDictionary
                {
                    SVProgressHUD.showError(withStatus: responseObj["message"] as? String ?? "")
                }
            }
        }
        catch
        {
            
        }
    }
    
    
}


