//
//  HomePlayersListUITableViewCell.swift
//  ioscricketapp
//
//  Created by mobiledev on 10/5/2024.
//

import UIKit

class HomePlayersListUITableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var roleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
