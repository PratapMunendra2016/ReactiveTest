//
//  ViewModel.swift
//  reactive
//
//  Created by Munendra Pratap on 25/10/16.
//  Copyright © 2016 Munendra Pratap Singh. All rights reserved.
//

import Foundation

class ViewModel{
    
    var  projects = [ProjectModel]()
    var searchKey:NSString!
    let responseArr: NSMutableArray = [ ]
    
    typealias CompletionBlock = (response:NSMutableArray,success:Bool) -> Void
    
    func getProjectList(pageNo:Int, complete:CompletionBlock) {
//        if searchKey.length>0 {
            let   url  = NSURL(string: "https://api.github.com/search/repositories?q=\(searchKey)+language:assembly&sort=stars&order=desc&page=\(pageNo)")
            VTWebservice.sharedInstance.webHelper(url! ){ (response:NSString,success:Bool) in
                let JSONData = response.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                let responseDic: NSDictionary = try! NSJSONSerialization.JSONObjectWithData(JSONData!, options:[]) as! NSDictionary
                if(success){
                    
                    let dataArray = responseDic["items"] as! NSArray;
                    for item in dataArray {
                        let obj = item as! NSDictionary
                        self.responseArr.addObject(ProjectModel(json: obj))
                    }
                    print(responseDic)
                    complete(response:self.responseArr ,success: true)
                    
                }else{
                    complete(response:self.responseArr ,success: false)
                }
            }
//        }
    }
}
