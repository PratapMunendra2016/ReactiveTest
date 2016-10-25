//
//  ViewController.swift
//  reactive
//
//  Created by Munendra Pratap on 25/10/16.
//  Copyright © 2016 Munendra Pratap Singh. All rights reserved.
//

import UIKit
import ReactiveCocoa

class ViewController: UIViewController {
    @IBOutlet weak var searchBarText: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var searchString : String = ""
    var viewModelObject = ViewModel(fromString:"",pageNO: 1)
    
    private var bindingHelper: TableViewBindingHelper<Model>!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModelObject.navigation=self.navigationController!
        let magnifyingGlassAttachment = NSTextAttachment(data: nil, ofType: nil)
        magnifyingGlassAttachment.image = UIImage(named: "search")
        
        let magnifyingGlassString = NSAttributedString(attachment: magnifyingGlassAttachment)
        let attributedText = NSMutableAttributedString(attributedString: magnifyingGlassString)
        
        let searchString = NSAttributedString(string: " Search")
        attributedText.appendAttributedString(searchString)
        searchBarText.attributedPlaceholder = attributedText
        
        searchBarText.rac_textSignal() ~> RAC(self.viewModelObject, "searchKey")
        
        bindingHelper = TableViewBindingHelper(tableView: tableView, sourceSignal: self.viewModelObject.resultArray.producer, selectionCommand: self.viewModelObject.executeCellSelection,viewModel:viewModelObject)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.title="Git Trending"
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        self.title="Back"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}