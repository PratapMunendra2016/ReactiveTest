//
//  TableViewBindingHelper.swift
//  ReactiveSwiftFlickrSearch
//
//  Created by Varun Tyagi on 21/10/16.
//  Copyright © 2016 Varun Tyagi . All rights reserved.
//

import UIKit
import ReactiveCocoa
import Result

@objc protocol ReactiveView {
    func bindViewModel(viewModel: AnyObject)
}

// a helper that makes it easier to bind to UITableView instances

class TableViewBindingHelper<T: AnyObject> : NSObject {
    
    //MARK: Properties
    
    var delegate: UITableViewDelegate?
    private let tableView: UITableView
    private let selectionCommand: RACCommand?
    private let dataSource: DataSource
    private let viewModel: ViewModel
    
    //MARK: Public API
    init(tableView: UITableView, sourceSignal: SignalProducer<[T], NoError>, selectionCommand: RACCommand? = nil,viewModel: ViewModel) {
        self.tableView = tableView
        self.selectionCommand = selectionCommand
        self.viewModel=viewModel
        dataSource = DataSource(data: nil, selectionCommand: selectionCommand,viewModel: viewModel)
        super.init()
        
        sourceSignal.startWithNext { [weak self] data in
            print(data)
            self?.dataSource.data = data.map({ $0 as AnyObject })
            dispatch_async(dispatch_get_main_queue()) {
                self?.tableView.reloadData()
            }
        }
    
        self.tableView.dataSource = dataSource
        self.tableView.delegate = dataSource
    }
}

class DataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
//    private let templateCell: UITableViewCell
    private let viewModel: ViewModel
    var data: [AnyObject]?
    var selectionCommand: RACCommand?

    
    init(data: [AnyObject]?, selectionCommand:RACCommand?,viewModel: ViewModel) {
        self.data = data
        self.viewModel = viewModel
        self.selectionCommand=selectionCommand
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == (self.data!.count-1){
            self.viewModel.pageNO+1;
            self.viewModel.getProjectList();
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("ProjectListCell"),
            
            reactiveView = cell as? ReactiveView else {
                return UITableViewCell()
        }
        
        reactiveView.bindViewModel(data![indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
         if self.selectionCommand != nil {
        self.selectionCommand?.execute(data![indexPath.row])
            print("did select called");

        }
    
       
    }
    
//    - (RACCommand *)selectionCommand {
//    self.selectionCommand = [[RACCommand alloc]
//    initWithSignalBlock:^RACSignal *(CETweetViewModel *selected) {
//    NSLog(selected.status);
//    return [RACSignal empty];
//    }];
//    }
}