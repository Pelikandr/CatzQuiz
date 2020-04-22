//
//  GuideCollectionViewCell.swift
//  CatzQuiz
//
//  Created by pelikandr on 22/04/2020.
//  Copyright © 2020 pelikandr. All rights reserved.
//

import UIKit

class GuideCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var catImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.backgroundColor = UIColor.random()
        contentView.layer.cornerRadius = 5
        catImageView.layer.cornerRadius = 5
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        catImageView.image = nil
        titleLabel.text = nil
    }
}
