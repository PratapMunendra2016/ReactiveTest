//
//  ProjectTableViewCell.swift
//  reactSwift
//
//  Created by Munendra Pratap on 21/10/16.
//  Copyright © 2016 Munendra Pratap Singh. All rights reserved.
//

import UIKit

class ProjectTableViewCell: UITableViewCell {

    
    @IBOutlet weak var projectNameLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var StarsLbl: UILabel!
    
    var data: ProjectModel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setModelValue(data:ProjectModel){
        
       // let data:ProjectModel! = service.responseArr[indexPath.row] as! ProjectModel
        self.projectNameLbl.text = data.developerName
        self.StarsLbl.text = String(format: "Stars :  %d",data.stars)
        self.descLbl.text = data.description
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
