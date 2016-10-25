//
//  ProjectModel.swift
//  reactive
//
//  Created by Munendra Pratap on 25/10/16.
//  Copyright © 2016 Munendra Pratap Singh. All rights reserved.
//

import Foundation

class Model{
    var projectName: String
    var stars: Int
    var forks: Int
    var description : String
    var developerName :String
    var devloperImage : String
    
    init(json: NSDictionary) {
        
        self.projectName = json.valueForKey("full_name") as! String!
        self.stars = json.valueForKey("stargazers_count") as! Int!
        self.forks = json.valueForKey("forks_count") as! Int!
        if ((json.valueForKey("description")?.isKindOfClass(NSNull)) != nil) {
            self.description = "Not Available"
        }else{
            self.description = json.valueForKey("description") as! String!
        }
        self.developerName = json.valueForKey("name") as! String!
        if json.objectForKey("owner")?.valueForKey("avatar_url") == nil {
            self.devloperImage = " "
        }else{
            self.devloperImage = json.objectForKey("owner")?.valueForKey("avatar_url") as! String!
        }
    }

}