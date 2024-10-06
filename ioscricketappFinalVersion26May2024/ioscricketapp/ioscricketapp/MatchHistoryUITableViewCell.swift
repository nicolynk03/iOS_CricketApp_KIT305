//
//  MatchHistoryUITableViewCell.swift
//  ioscricketapp
//
//  Created by mobiledev on 25/5/2024.
//

import UIKit

class MatchHistoryUITableViewCell: UITableViewCell {

    @IBOutlet var HomeTeamNameMatchHistory: UILabel!
    @IBOutlet var VersusLabelMatchHistory: UILabel!
    @IBOutlet var AwayTeamNameMatchHistory: UILabel!
    @IBOutlet var WicketLostLabelMatchHistory: UILabel!
    @IBOutlet var ScoreSeparatorMatchHistory: UILabel!
    @IBOutlet var TotalRunsLabelMatchHistory: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
