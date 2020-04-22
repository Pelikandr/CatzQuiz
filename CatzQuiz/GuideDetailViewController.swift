//
//  GuideDetailViewController.swift
//  CatzQuiz
//
//  Created by pelikandr on 22/04/2020.
//  Copyright © 2020 pelikandr. All rights reserved.
//

import UIKit

class GuideDetailTableViewController: UITableViewController {

    @IBOutlet weak var catImageView: UIImageView!
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var breed: Breed?

    override func viewDidLoad() {
        super.viewDidLoad()
        breedLabel.text = breed?.name
        descriptionTextView.text = breed?.description
        view.backgroundColor = UIColor.randomLight()
    
        catImageView.setImage(from: breed?.sampleImageURL)
    }
    
    @IBAction func onMenu(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
}
