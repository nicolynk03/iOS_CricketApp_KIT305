//
//  AwayPlayersListUITableViewCell.swift
//  ioscricketapp
//
//  Created by mobiledev on 11/5/2024.
//

import UIKit

class AwayPlayersListUITableViewCell: UITableViewCell {

    @IBOutlet var awayNameLabel: UILabel!
    @IBOutlet var awayRoleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
