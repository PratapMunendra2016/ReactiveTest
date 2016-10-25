//
//  ProjectTableViewCell.swift
//  reactSwift
//
//  Created by Munendra Pratap on 21/10/16.
//  Copyright © 2016 Munendra Pratap Singh. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Result

class ProjectTableViewCell: UITableViewCell,ReactiveView {

    
    @IBOutlet weak var projectNameLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var StarsLbl: UILabel!
    
    var data: Model!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bindViewModel(viewModel: AnyObject) {
        let devloper = viewModel as! Model
        projectNameLbl.text = devloper.projectName
        StarsLbl.text = String(format: "Stars :  %d",devloper.stars)
        descLbl.text = devloper.description
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
