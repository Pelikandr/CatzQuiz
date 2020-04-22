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
    
        getImage(with: breed!.id) { [weak self] (image: CatImage) in
            guard let self = self else { return }
            self.saveImage(with: image.url) { (localURL: URL) in
                if let image = UIImage(contentsOfFile: localURL.absoluteString) {
                    self.catImageView.image = image
                }
            }
        }
    }
    
    private func getImage(with breedID: String, completion: ((CatImage) -> Void)?) {
        Network.shared.getImage(with: breedID) { (error: Error?, image: [CatImage]?) in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            } else if let image = image?.first {
                completion?(image)
            } else {
                print("ERROR: No data")
            }
        }
    }
    
    private func saveImage(with url: String, completion: ((URL) -> Void)?) {
        Network.shared.saveImage(from: url) { (error: Error?, localURL: URL?) in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            } else if let localURL = localURL {
                completion?(localURL)
            } else {
                print("ERROR: No data")
            }
        }
    }

}
