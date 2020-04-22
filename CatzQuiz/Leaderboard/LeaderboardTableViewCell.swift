//
//  LeaderboardTableViewCell.swift
//  CatzQuiz
//
//  Created by pelikandr on 22/04/2020.
//  Copyright © 2020 pelikandr. All rights reserved.
//

import UIKit

class LeaderboardTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        scoreLabel.text = nil
    }
}
