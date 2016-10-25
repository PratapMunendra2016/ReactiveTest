//
//  DetailViewController.swift
//  reactive
//
//  Created by Munendra Pratap on 25/10/16.
//  Copyright © 2016 Munendra Pratap Singh. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Result

class DetailViewController: UIViewController {
    
    @IBOutlet weak var devloperImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UITextView!
    @IBOutlet weak var readmeTxtView: UITextView!
    @IBOutlet weak var forksBtn: UIButton!
    @IBOutlet weak var starsBtn: UIButton!
    
    var dataModel:Model!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInitialView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setupInitialView() {
        
        self.devloperImg.layer.cornerRadius=self.devloperImg.frame.size.width/2
        self.devloperImg.layer.masksToBounds = true
        
        //call image download method
        signalForImage(NSURL(string:self.dataModel.devloperImage)!).deliverOn(RACScheduler.mainThreadScheduler())
            .subscribeNextAs {
                (image: UIImage) -> () in
                self.devloperImg.image = image
        }
        
        // set data to ui
        self.title=self.dataModel.developerName
        nameLbl.text=self.dataModel.developerName;
        descriptionLbl.text=self.dataModel.description;
        starsBtn.setTitle(String(format: "%d Stars",self.dataModel.stars), forState: UIControlState.Normal)
        
        starsBtn.layer.borderColor = UIColor(red: 96.0/255.0, green: 125.0/255.0, blue: 139.0/255.0, alpha: 1.0).CGColor
        starsBtn.layer.borderWidth=1
        starsBtn.layer.masksToBounds = true
        
        forksBtn.layer.borderColor = UIColor(red: 96.0/255.0, green: 125.0/255.0, blue: 139.0/255.0, alpha: 1.0).CGColor
        forksBtn.layer.borderWidth=1
        forksBtn.layer.masksToBounds = true
        forksBtn.setTitle(String(format: "%d Forks",self.dataModel.forks), forState: UIControlState.Normal)
    }

    
    //method to download image in Reactive
    func signalForImage(imageUrl: NSURL) -> RACSignal{
        let scheduler = RACScheduler(priority: RACSchedulerPriorityBackground)
        let signal = RACSignal.createSignal({
            (subscriber: RACSubscriber!) -> RACDisposable! in
            let data = NSData(contentsOfURL: imageUrl)
            let image = UIImage(data: data!)
            subscriber.sendNext(image)
            subscriber.sendCompleted()
            return nil
        })
        return signal.subscribeOn(scheduler)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
