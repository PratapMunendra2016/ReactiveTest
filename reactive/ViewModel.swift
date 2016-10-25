//
//  ViewModel.swift
//  reactive
//
//  Created by Munendra Pratap on 25/10/16.
//  Copyright © 2016 Munendra Pratap Singh. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Result
import Foundation


class ViewModel : NSObject{
    typealias CompletionHandler = (response:NSString,success:Bool) -> Void
    var navigation : UINavigationController = UINavigationController()
    var searchKey:NSString!
    var pageNO:Int!
    var executeCellSelection: RACCommand?
    let detailVC = DetailViewController()
    var resultArray = MutableProperty<[Model]>([Model]())
    var someProperty: NSString 
    var task:NSURLSessionTask?
    var responseString:NSString = ""
    
    init(fromString string: NSString, pageNO: Int) {
        self.pageNO=pageNO
        self.searchKey=""
        self.someProperty = string
        super.init()
        
        self.rac_valuesForKeyPath("searchKey",
            observer: self).subscribeNext{
                (x) in print("swift search text is valid \(x)")
                
                self.getProjectList()
        }
        
        self.executeCellSelection = RACCommand() {
            (model:AnyObject!) -> RACSignal in
            
            let detailVC:DetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
            
            detailVC.dataModel=model as! Model
            self.navigation.pushViewController(detailVC, animated: true)
            return RACSignal.empty()
        }
    }
    
    func getProjectList() {
        
        let   url  = NSURL(string: "https://api.github.com/search/repositories?q=\(searchKey)+language:assembly&sort=stars&order=desc&page=\(self.pageNO)")
        self.sendRequestForData(url! ){ (response:NSString,success:Bool) in
            let JSONData = response.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            let responseDic: NSDictionary = try! NSJSONSerialization.JSONObjectWithData(JSONData!, options:[]) as! NSDictionary
            
            if(success){
                
                if self.pageNO==1{
                    self.resultArray.value.removeAll()
                }
                let dataArray = responseDic["items"] as! NSArray;
                if dataArray.count>0{
                    for item in dataArray {
                        let obj = item as! NSDictionary
                        self.resultArray.value.append(Model(json: obj))
                    }
                }else{
                    self.resultArray.value.removeAll()
                }
            }
        }
    }
    
    
    func sendRequestForData( url: NSURL ,completionHandler: CompletionHandler) {
        
        let request = NSMutableURLRequest(URL: url)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "GET"
        
        request.addValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept-Encoding")
        request.addValue("en-US", forHTTPHeaderField: "Accept-Language")

        if (task != nil){
            if task!.state == NSURLSessionTaskState.Running {
                task?.cancel()
            }
        }
        task = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
            guard let httpResponse = response as? NSHTTPURLResponse, receivedData = data
                else {
                    print("error: not a valid http response")
                    self.responseString="{\"code\":\"500\", \"message\":\"Problem while fetching the data from server. Please try again or check your device network.\"}"
                    completionHandler(response:self.responseString ,success: false)
                    return
            }
            
            switch (httpResponse.statusCode){
                
            case 200:
                
                self.responseString = NSString (data: receivedData, encoding: NSUTF8StringEncoding)!
                completionHandler(response:self.responseString ,success: true)
                
                break
            case 400:
                
                break
            default:
                self.responseString="{\"code\":\"500\", \"message\":\"Problem while fetching the data from server. Please try again or check your device network.\"}"
                completionHandler(response:self.responseString ,success: false)
                
            }
            
        });
        
        task!.resume()
        
    }
}
