//
//  ViewController.swift
//  reactive
//
//  Created by Munendra Pratap on 25/10/16.
//  Copyright © 2016 Munendra Pratap Singh. All rights reserved.
//

import UIKit
import ReactiveCocoa


extension RACSignal {
    func subscribeNextAs<T>(nextClosure:(T) -> ()) -> () {
        self.subscribeNext {
            (next: AnyObject!) -> () in
            let nextAsT = next as! T
            nextClosure(nextAsT)
        }
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var searchTxt: UITextField!
    @IBOutlet weak var projectListTbl: UITableView!
    
    var service = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTxt.rac_textSignal().subscribeNext {  (next:AnyObject!) -> () in
            let text = next as! String
            print(text)
            self.service.searchKey=text;
            self.service.getProjectList { (response, success) in
                dispatch_async(dispatch_get_main_queue()) {
                    self.projectListTbl.reloadData()
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return service.responseArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ProjectListCell", forIndexPath: indexPath) as! ProjectTableViewCell
        
        let data:ProjectModel! = service.responseArr[indexPath.row] as! ProjectModel
        cell.setModelValue(data)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let detailViewController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
//        detailViewController.dataModel = service.responseArr[indexPath.row] as! ProjectModel
//        self.navigationController!.pushViewController(detailViewController, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

