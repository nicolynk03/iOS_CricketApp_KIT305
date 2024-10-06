//
//  SpecificMatchUITableViewCell.swift
//  ioscricketapp
//
//  Created by mobiledev on 26/5/2024.
//

import UIKit

class SpecificMatchUITableViewCell: UITableViewCell {

    //@IBOutlet var batterNameLabelMatchHistoryRecord: UIStackView!
    //@IBOutlet var bowlerNameLabelMatchHistoryRecord: UIStackView!
    
    /*@IBOutlet var batterNameLabelMatchHistoryRecord: UIStackView!
     @IBOutlet var bowlerNameLabelMatchHistoryRecord: UIStackView!
     @IBOutlet var runsLabelMatchHistoryRecord: UILabel!
     @IBOutlet var wicketsLabelMatchHistoryRecord: UILabel!*/
    
    @IBOutlet var batterNameLabelMatchHistoryRecord: UILabel!
    @IBOutlet var bowlerNameLabelMatchHistoryRecord: UILabel!
    @IBOutlet var nonStrikerLabelMatchHistoryRecord: UILabel!
    @IBOutlet var runsLabelMatchHistoryRecord: UILabel!
    @IBOutlet var wicketsLabelMatchHistoryRecord: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
