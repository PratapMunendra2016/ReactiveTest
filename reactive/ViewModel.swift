//
//  ViewModel.swift
//  reactive
//
//  Created by Munendra Pratap on 25/10/16.
//  Copyright © 2016 Munendra Pratap Singh. All rights reserved.
//

import Foundation
import ReactiveCocoa

class ViewModel{

    var searchText :NSString = ""
    var searchResults: NSArray = []
    var searchCommand : RACCommand!
    
}
