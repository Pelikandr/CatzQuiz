//
//  GuideViewController.swift
//  CatzQuiz
//
//  Created by pelikandr on 22/04/2020.
//  Copyright © 2020 pelikandr. All rights reserved.
//

import UIKit

class GuideViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let adapter = GuideAdapter()
    var breeds = [Breed]()
    var selectedBreed: Breed?

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = adapter
        collectionView.delegate = adapter
        getAllBreeds { [weak self] (breeds) in
            guard let self = self else { return }
            self.breeds = breeds
            self.adapter.breeds = self.breeds
        }
        adapter.onCatSelected = { [weak self] (breed: Breed) in
            guard let self = self else { return }
            self.selectedBreed = breed
        }
    }

    private func getAllBreeds(completion: (([Breed]) -> Void)?) {
        Network.shared.getAllBreeds { (error: Error?, data: [Breed]?) in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            } else if let data = data {
                completion?(data)
            } else {
                print("ERROR: No data")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: nil)
        if let next = segue.destination as? GuideDetailTableViewController {
            next.breed = selectedBreed
        }
    }
    
}
