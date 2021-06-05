//
//  RegistrationWordTableViewCell.swift
//  Yometa
//
//  Created by 川上知宏 on 2021/06/02.
//

import UIKit

class RegistrationWordTableViewCell: UITableViewCell {
    
    @IBOutlet var gazou: UIImageView!
    @IBOutlet var english: UILabel!
    @IBOutlet var japanese: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
