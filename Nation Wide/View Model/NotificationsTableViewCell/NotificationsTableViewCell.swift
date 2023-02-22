//
//  NotificationsTableViewCell.swift
//  Nation Wide
//
//  Created by Solution Surface on 17/06/2022.
//

import UIKit

class NotificationsTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dividerView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
